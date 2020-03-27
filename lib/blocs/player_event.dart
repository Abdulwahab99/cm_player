part of 'player_bloc.dart';

@immutable
abstract class PlayerEvent {}

class NextSong extends PlayerEvent {}

class PreviousSong extends PlayerEvent {}

class PauseSong extends PlayerEvent {}

class PlaySong extends PlayerEvent {
  final SongInfo song;
  PlaySong({this.song});
}

class SeekTo extends PlayerEvent {
  final int value;
  SeekTo(this.value);
}

class AddState extends PlayerEvent {
  final PlayerState state;
  AddState(this.state);
}

class ResumeSong extends PlayerEvent {}

class StopPlayer extends PlayerEvent {}

class AppStarted extends PlayerEvent {}

class LoadArtistSongs extends PlayerEvent {
  final ArtistInfo artist;
  LoadArtistSongs(this.artist);
}

class LoadAlbumSongs extends PlayerEvent {
  final AlbumInfo album;
  LoadAlbumSongs(this.album);
}

class LoadPlSongs extends PlayerEvent {
  final PlaylistInfo pl;
  LoadPlSongs(this.pl);
}

class AddToFav extends PlayerEvent {
  SongInfo song;
  AddToFav({this.song});
}

class RemFromFav extends PlayerEvent {
  SongInfo song;
  RemFromFav({this.song});
}

class CreatePlayList extends PlayerEvent {
  String name;
  CreatePlayList({this.name});
}

class RemPlayList extends PlayerEvent {
  PlaylistInfo pl;
  RemPlayList({this.pl});
}
class AddToPL extends PlayerEvent {
  PlaylistInfo pl;
  SongInfo song;
  AddToPL({this.song,this.pl});
}
class LoadPlayListSongs extends PlayerEvent {
  PlaylistInfo pl;
  LoadPlayListSongs({this.pl});
}


class RemFromPlayList extends PlayerEvent {
  PlaylistInfo pl;
  SongInfo song;
  RemFromPlayList({this.song,this.pl});
}
