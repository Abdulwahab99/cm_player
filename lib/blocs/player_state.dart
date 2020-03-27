part of 'player_bloc.dart';

class PlayerState {
  List<ArtistInfo> allArtists = [];
  List<SongInfo> allSongs = [];
  List<ArtistInfo> fallArtists = [];
  List<SongInfo> fallSongs = [];
  List<PlaylistInfo> allPlaylists = [];
  List<AlbumInfo> allAlbums = [];
  List<SongInfo> currentPlaylist = [];
  List<SongInfo> artistSongs = [];
  List<SongInfo> playlistSongs = [];
  List<SongInfo> favoriteIds = [];
  PlaylistInfo fav;
  List<SongInfo> plSongs = [];
  List<SongInfo> albumSongs = [];
  SongInfo currentPlaying;
  bool isPaused;
  bool isStopped;
  int activeTab;
  int activePlayingTab;
  int isReplay;

  bool isAllSongsLoading;
  bool isArtistSongsLoading;

  PlayerState({
    this.allArtists,
    this.allSongs,
    this.fallArtists,
    this.fallSongs,
    this.allAlbums,
    this.allPlaylists,
    this.currentPlaylist,
    this.fav,
    this.artistSongs,
    this.playlistSongs,
    this.albumSongs,
    this.plSongs,
    this.favoriteIds,
    this.currentPlaying,
    this.isPaused = false,
    this.isStopped = false,
    this.activePlayingTab,
    this.activeTab,
    this.isAllSongsLoading = false,
    this.isArtistSongsLoading = false,
    this.isReplay = 0,
  });

  copyWith(
      {List<ArtistInfo> allArtists,
      List<SongInfo> allSongs,
        List<ArtistInfo> fallArtists,
        List<SongInfo> fallSongs,
      List<PlaylistInfo> allPlaylists,
      List<AlbumInfo> allAlbums,
      List<SongInfo> currentPlaylist,
      List<SongInfo> artistSongs,
      List<SongInfo> playlistSongs,
      List<SongInfo> plSongs,
      List<SongInfo> albumSongs,
      List<SongInfo> favoriteIds,
      PlaylistInfo fav,
      currentPlaying,
      isPaused,
      isStopped,
      activePlayingTab,
      activeTab,
      isAllSongsLoading,
        isReplay,
      isArtistSongsLoading}) {
    return PlayerState(
      isAllSongsLoading: isAllSongsLoading ?? this.isAllSongsLoading,
      allArtists: allArtists ?? this.allArtists,
      fallArtists: fallArtists ?? this.fallArtists,
      isArtistSongsLoading: isArtistSongsLoading ?? this.isArtistSongsLoading,
      allSongs: allSongs ?? this.allSongs,
      fallSongs: fallSongs ?? this.fallSongs,
      allAlbums: allAlbums ?? this.allAlbums,
      allPlaylists: allPlaylists ?? this.allPlaylists,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      artistSongs: artistSongs ?? this.artistSongs,
      playlistSongs: playlistSongs ?? this.playlistSongs,
      albumSongs: albumSongs ?? this.albumSongs,
      plSongs: plSongs ?? this.plSongs,
      fav: fav ?? this.fav,
      currentPlaylist: currentPlaylist ?? this.currentPlaylist,
      currentPlaying: currentPlaying ?? this.currentPlaying,
      isPaused: isPaused ?? this.isPaused,
      isStopped: isStopped ?? this.isStopped,
      isReplay: isReplay ?? this.isReplay,
      activeTab: activeTab ?? this.activeTab,
      activePlayingTab: activePlayingTab ?? this.activePlayingTab,
    );
  }
}

class InitialPlayerState extends PlayerState {}
