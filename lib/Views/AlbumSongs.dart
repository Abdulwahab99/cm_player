import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/Widgets/ChoosenSongWidget.dart';
import 'package:flutter_music_neumorphism/Widgets/NeumophismContainer.dart';
import 'package:flutter_music_neumorphism/Widgets/SongWidget.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlbumSongs extends StatefulWidget {
  AlbumInfo album;
  AlbumSongs({Key key, this.album}) : super(key: key);

  @override
  _AlbumSongsState createState() => _AlbumSongsState();
}

class _AlbumSongsState extends State<AlbumSongs> {

  PlayerBloc playerBloc;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  initState() {
    playerBloc = BlocProvider.of<PlayerBloc>(context);
    playerBloc.add(LoadAlbumSongs(widget.album));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1080, height: 2160, allowFontScaling: false);
    return Scaffold(
        backgroundColor: AppColor.Background,
        body: SafeArea(
            child: BlocConsumer<PlayerBloc, PlayerState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state.albumSongs == null || state.albumSongs?.length == 0) {
              return Center(
                child: Text('No Song Found'),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Hero(
                            tag: 'leftButtonHero',
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: NeumorPhismContainer(
                                width: ScreenUtil().setWidth(130),
                                height: ScreenUtil().setWidth(130),
                                backgroundColor: AppColor.NavigateButton,
                                backgroundDarkerColor: AppColor.Background,
                                child: Icon(
                                  Icons.arrow_back,
                                  size: ScreenUtil().setSp(50),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${widget.album.title}',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(40),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: widget.album.albumArt != null
                                ? FileImage(
                                    File(widget.album.albumArt),
                                  )
                                : Container(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                      SizedBox(height: 15,),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: ListView.builder(
                            itemCount: state.albumSongs?.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (state.albumSongs[index].id ==
                                  state.currentPlaying?.id) {
                                return ChoosenSongWidget(
                                  onPressPlay: (SongInfo song) {
                                    if (!state.isPaused) {
                                      playerBloc.add(
                                        PauseSong(),
                                      );
                                    } else {
                                      playerBloc.add(
                                        ResumeSong(),
                                      );
                                    }
                                  },
                                  song: state.albumSongs[index],
                                );
                              } else {
                                return SongWidget(
                                  song: state.albumSongs[index],
                                  onPressPlay: (SongInfo song) {
                                    playerBloc.add(PlaySong(song: song));
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        )));
  }
}
