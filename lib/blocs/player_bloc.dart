import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_music_neumorphism/Views/VideoScreen.dart';
import 'package:media_player/data_sources.dart';
import 'package:media_player/media_player.dart';
import 'package:meta/meta.dart';

part 'player_event.dart';
part 'player_state.dart';

enum NavigationOptions { ARTISTS, ALBUMS, SONGS, GENRES, PLAYLISTS }
enum SearchBarState { COLLAPSED, EXPANDED }

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  MediaPlayer player;
  PlayerBloc() {
    player = MediaPlayerPlugin.create(
      isBackground: true,
      showNotification: true,
      onEvent: onPlayerEvent,
    );
    initPlayer();
  }
  Future initPlayer() async {
    await player.initialize();
    // listenToPlayerEvent();
  }

  onPlayerEvent(Map event) {
    switch (event['event']) {
      case 'paused':
        this.add(PauseSong());
        break;
      case 'play':
        this.add(AddState(this.state.copyWith(isPaused: false)));
        break;
      case 'completed':
        this.add(NextSong());
        break;
      case 'initialized':
        if (this.state.currentPlaylist != null) {

          this.add(AddState(this.state.copyWith(
              currentPlaying:
              this.state.currentPlaylist[event['current_index']])));

        }

        break;
    }
  }

  MediaFile toMedia(SongInfo s) {
    //print(s.filePath);
    return MediaFile(
      title: s.title,
      type: "audio",
      source: s.filePath,
      // source: "http://10.42.0.1/video.mp4", // this is my personal local server link when i don't have internet. u can ignore this.
      desc: s.artist,
      image: s.albumArtwork ?? '',
    );
  }

  setPlayList(List<SongInfo> songs) async {
    List<MediaFile> myList = songs.map((SongInfo s) => toMedia(s)).toList();
    await player.setPlaylist(Playlist(myList));
  }

  @override
  PlayerState get initialState => InitialPlayerState();

  Future<PlaylistInfo> getOrCreatePlayList(String name) async {
    PlaylistInfo pl = await findPlayList(name);
    if (pl == null) {
      FlutterAudioQuery.createPlaylist(playlistName: name);
    }
    return pl;
  }

  setReplayOne(){
    if(state.isReplay==0){
      state.isReplay=1;
      player.setLooping(true,mode:1);
    }else if(state.isReplay==1){
      state.isReplay=2;
      player.setLooping(true,mode:2);
    }else{
      state.isReplay=0;
      player.setLooping(false);
    }

    this.add(AddState(state.copyWith(isReplay: state.isReplay)));
  }

  findPlayList(String name) async {
    List<PlaylistInfo> pl = await audioQuery.getPlaylists();
    PlaylistInfo playlistInfo;
    pl.forEach((p) {
      if (p.name.toLowerCase() == name.toLowerCase()) {
        playlistInfo = p;
      }
    });
    return playlistInfo;
  }

  @override
  Stream<PlayerState> mapEventToState(PlayerEvent event) async* {
    if (event is AppStarted) {
      yield this.state.copyWith(isAllSongsLoading: true);
      List<SongInfo> songs = await audioQuery.getSongs();
      await setPlayList(songs);
      var fav = await getOrCreatePlayList("Favorites");
      yield this.state.copyWith(
          allSongs: songs,
          currentPlaylist: songs,
          activePlayingTab: 0,
          fav: fav,
          isAllSongsLoading: false,
          favoriteIds: await audioQuery.getSongsFromPlaylist(playlist: fav));
      List<ArtistInfo> artists = await audioQuery.getArtists();
      this.add(AddState(this.state.copyWith(allArtists: artists)));
      print(this.state);
    }

    if (event is LoadArtistSongs) {
      yield this.state.copyWith(isArtistSongsLoading: true);
      List<SongInfo> songs =
          await audioQuery.getSongsFromArtist(artist: event.artist.name);
      //setPlayList(songs);
      yield this.state.copyWith(
            artistSongs: songs,
            currentPlaylist: songs,
            activePlayingTab: 1,
            isArtistSongsLoading: false,
          );
    }

    if (event is LoadAlbumSongs) {
      List<SongInfo> songs =
          await audioQuery.getSongsFromAlbum(albumId: event.album.id);
      //setPlayList(songs);
      yield this.state.copyWith(
            albumSongs: songs,
            currentPlaylist: songs,
            activePlayingTab: 2,
          );
    }

    if (event is LoadPlSongs) {
      List<SongInfo> songs =
          await audioQuery.getSongsFromPlaylist(playlist: event.pl);
      //setPlayList(songs);
      yield this.state.copyWith(
            plSongs: songs,
            currentPlaylist: songs,
            activePlayingTab: 3,
          );
    }

    if (event is AddState) {
      yield event.state;
    }

    if (event is PlaySong) {
      if (state.isPaused) {
        await player.play();
      }
      print(event.song);
      await setPlayList(state.currentPlaylist);
      int nextIndex = state.currentPlaylist.indexOf(event.song);
      await player.playAt(nextIndex);
      await player.play();
      yield this.state.copyWith(
            currentPlaying: event.song,
            isPaused: false,
          );
    }

    if (event is ResumeSong) {
      await player.play();
      yield this.state.copyWith(isPaused: false);
    }

    if (event is StopPlayer) {
      await player.pause();
      yield this.state.copyWith(isStopped: true);
    }

    if (event is PauseSong) {
      if (!state.isPaused) {
        await player.pause();
        yield this.state.copyWith(isPaused: true);
      }
    }

    if (event is NextSong) {
      await setPlayList(state.currentPlaylist);
      int nextIndex =
          (state.currentPlaylist.indexOf(state.currentPlaying) + 1) %
              state.currentPlaylist.length;
      player.playAt(nextIndex);
      await player.play();
      yield this.state.copyWith(
            currentPlaying: state.currentPlaylist[nextIndex],
            isPaused: false,
          );
    }
    if (event is PreviousSong) {
      int nextIndex =
          (state.currentPlaylist.indexOf(state.currentPlaying) - 1) %
              state.currentPlaylist.length;
      player.playAt(nextIndex);
      await player.play();
      yield this.state.copyWith(
            currentPlaying: state.currentPlaylist[nextIndex],
            isPaused: false,
          );
    }

    if (event is SeekTo) {
      player.seek(event.value);
    }

    if (event is AddToFav) {
      state.fav.addSong(song: event.song);
      var fav = await getOrCreatePlayList("Favorites");
      yield this.state.copyWith(
            fav: fav,
            favoriteIds: await audioQuery.getSongsFromPlaylist(
              playlist: fav,
            ),
          );
    }
    if (event is RemFromFav) {
      state.fav.removeSong(song: event.song);
      var fav = await getOrCreatePlayList("Favorites");
      yield this.state.copyWith(
            fav: fav,
            favoriteIds: await audioQuery.getSongsFromPlaylist(
              playlist: fav,
            ),
          );
    }

    if(event is RemFromPlayList){
      await event.pl.removeSong(song: event.song);
      var songs = await audioQuery.getSongsFromPlaylist(
        playlist: event.pl,
      );
      yield this.state.copyWith(
        playlistSongs: songs,
      );
    }

    if(event is LoadPlayListSongs){
      var songs = await audioQuery.getSongsFromPlaylist(
        playlist: event.pl,
      );
      yield this.state.copyWith(
        currentPlaylist: songs,
        playlistSongs: songs,
      );
    }

    if (event is AddToPL) {
      event.pl.addSong(song: event.song);
    }

    if (event is CreatePlayList) {
      await FlutterAudioQuery.createPlaylist(playlistName: event.name);
      yield this.state.copyWith(
            allPlaylists: await audioQuery.getPlaylists(),
          );
    }

    if (event is RemPlayList) {
      await FlutterAudioQuery.removePlaylist(playlist: event.pl);
      yield this.state.copyWith(
            allPlaylists: await audioQuery.getPlaylists(),
          );
    }
  }


  static const List<String> _artistSortNames = [
    "DEFAULT",
    "MORE ALBUMS NUMBER FIRST",
    "LESS ALBUMS NUMBER FIRST",
    "MORE TRACKS NUMBER FIRST",
    "LESS TRACKS NUMBER FIRST"
  ];

  static const List<String> _albumsSortNames = [
    "DEFAULT",
    "ALPHABETIC ARTIST NAME",
    "MORE SONGS NUMBER FIRST",
    "LESS SONGS NUMBER FIRST",
    "MOST RECENT YEAR",
    "OLDEST YEAR"
  ];

  static const List<String> _songsSortNames = [
    "DEFAULT",
    "ALPHABETIC COMPOSER",
    "GREATER DURATION",
    "SMALLER DURATION",
    "RECENT YEAR",
    "OLDEST YEAR",
    "ALPHABETIC ARTIST",
    "ALPHABETIC ALBUM",
    "GREATER TRACK NUMBER",
    "SMALLER TRACK NUMBER",
    "DISPLAY NAME"
  ];

  static const List<String> _genreSortNames = ["DEFAULT"];

  static const List<String> _playlistSortNames = [
    "DEFAULT",
    "NEWEST_FRIST",
    "OLDEST_FIRST"
  ];

  static const Map<NavigationOptions, List<String>> sortOptionsMap = {
    NavigationOptions.ARTISTS: _artistSortNames,
    NavigationOptions.ALBUMS: _albumsSortNames,
    NavigationOptions.SONGS: _songsSortNames,
    NavigationOptions.GENRES: _genreSortNames,
    NavigationOptions.PLAYLISTS: _playlistSortNames,
  };

  ArtistSortType _artistSortTypeSelected = ArtistSortType.DEFAULT;
  AlbumSortType _albumSortTypeSelected = AlbumSortType.DEFAULT;
  SongSortType _songSortTypeSelected = SongSortType.DEFAULT;
  GenreSortType _genreSortTypeSelected = GenreSortType.DEFAULT;
  PlaylistSortType _playlistSortTypeSelected = PlaylistSortType.DEFAULT;

  Future<void> setActiveTab(int index) async {
    if (index == 0) {
      state.currentPlaylist = state.allSongs;
      state.activeTab = index;
    }
    if (index == 1) {
      List<ArtistInfo> artists = await audioQuery.getArtists();
      this.add(AddState(this.state.copyWith(allArtists: artists)));
      state.currentPlaylist = state.artistSongs;
      state.activeTab = index;
    }
    if (index == 2) {
      PlaylistInfo fav = await getOrCreatePlayList("Favorites");
      state.currentPlaylist =
          await audioQuery.getSongsFromPlaylist(playlist: fav);
      state.activeTab = index;
    }
    if (index == 3) {
      List<PlaylistInfo> playLists = await audioQuery.getPlaylists();

      this.add(AddState(this.state.copyWith(allPlaylists: playLists)));
      state.activeTab = index;
    }
    if (index == 4) {
      List<AlbumInfo> albums = await audioQuery.getAlbums();
      this.add(AddState(this.state.copyWith(allAlbums: albums)));
      state.currentPlaylist = state.albumSongs;
      state.activeTab = index;
    }
    print('active tab $index');
  }

  applyFilter(String s){
    print(s.replaceAll(" ",""));
    this.add(AddState(this.state.copyWith(
      fallSongs: this.state.allSongs.where((song){
      return song.title.toLowerCase().contains(s.toLowerCase()) ||
          song.artist.toLowerCase().contains(s.toLowerCase()) ||
          song.title.replaceAll(" ", "").toLowerCase().contains(s.replaceAll(" ","").toLowerCase())
          || song.artist.replaceAll(" ","").toLowerCase().startsWith(s.replaceAll(" ","").toLowerCase()) ;
    },).toList(),
      fallArtists: this.state.allArtists.where((artist){
        return artist.name.toLowerCase().contains(s.toLowerCase()) || artist.name.toLowerCase().startsWith(s.toLowerCase());
      },).toList(),
    ),),);
  }
}
