import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/Views/AlbumSongs.dart';
import 'package:flutter_music_neumorphism/Views/ArtistSongs.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';

class AlbumWidget extends StatelessWidget {
  final Function onPressPlay;
  final AlbumInfo album;
  const AlbumWidget({
    Key key,
    this.album,
    this.onPressPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //return Text(artist.name);
    return GestureDetector(
      onTap: () {
        BlocProvider.of<PlayerBloc>(context).add(LoadAlbumSongs(this.album));
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => AlbumSongs(album: this.album)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: album.albumArt != null
                      ? FileImage(File(album.albumArt))
                      :Image.network(
                    'https://i.ytimg.com/vi/doT10lpO1hI/maxresdefault.jpg',
                    fit: BoxFit.cover,
                  ).image,
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            ),
            Positioned(
                child: Container(
              color: Colors.black.withOpacity(.3),
              child: ListTile(
                title: Text(
                  album.title,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${album.artist}',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 14),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
