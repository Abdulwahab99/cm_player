import 'package:flutter/material.dart';
import 'package:media_player/data_sources.dart';
import 'package:media_player/media_player.dart';
import 'package:media_player/ui.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

final FlutterAudioQuery audioQuery = FlutterAudioQuery();

class MyVideoScreen extends StatefulWidget {
  @override
  _MyVideoScreenState createState() => _MyVideoScreenState();
}

class _MyVideoScreenState extends State<MyVideoScreen> {
  MediaPlayer player;

  @override
  void initState() {
    // first argument for isBackground next for showNotification.
    player =
        MediaPlayerPlugin.create(isBackground: true, showNotification: true);
    initVideo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    print("dispose called");
    player.dispose();
  }

  void initVideo() async {
    await player.initialize();

    AssetImage a = AssetImage('store.png');

    List<SongInfo> songs = await audioQuery.getSongs();
   // await player.setSource(getMediaFileFromSongInfo(songs[0]));
    List<MediaFile> myList =songs.map((SongInfo s)=>getMediaFileFromSongInfo(s)).toList();
    await player.setPlaylist(Playlist(myList));
    player.play();
  }

  MediaFile getMediaFileFromSongInfo(SongInfo s){
    //print(s.filePath);
      return  MediaFile(
        title: s.title,
        type: "audio",
        source: s.filePath,
        // source: "http://10.42.0.1/video.mp4", // this is my personal local server link when i don't have internet. u can ignore this.
        desc: s.artist,
        image: s.albumArtwork??'',
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        VideoPlayerView(player),
        VideoProgressIndicator(
          player,
          allowScrubbing: true,
          padding: EdgeInsets.symmetric(vertical: 5.0),
        ),
        SizedBox(height: 20.0),
        buildButtons()
      ]),
    );
  }

  Widget buildButtons() {
    return Wrap(
      children: <Widget>[
        FlatButton(
          child: Text("Prev"),
          onPressed: () {
            player.playPrev();
          },
        ),
        FlatButton(
          child: Text("Play"),
          onPressed: () {
            player.play();
          },
        ),
        FlatButton(
          child: Text("Pause"),
          onPressed: () {
            player.pause();
          },
        ),
        FlatButton(
          child: Text("Next"),
          onPressed: () {
            player.playNext();
          },
        ),
        FlatButton(
          child: Text("stop"),
          onPressed: () {
            player.dispose();
          },
        ),
      ],
    );
  }
}