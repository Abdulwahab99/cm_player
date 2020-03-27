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

class PlaylistSongs extends StatefulWidget {
  PlaylistInfo pl;
  PlaylistSongs({Key key, this.pl}) : super(key: key);

  @override
  _PlaylistSongsState createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  PlayerBloc playerBloc;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  initState() {
    playerBloc = BlocProvider.of<PlayerBloc>(context);
    playerBloc.add(LoadPlayListSongs(pl:widget.pl));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1080, height: 2160, allowFontScaling: false);
    return Scaffold(
        backgroundColor: AppColor.Background,
        body: SafeArea(child: BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
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
                              widget.pl.name,
                              style: TextStyle(
                                  fontSize:20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Hero(
                            tag: 'rightButtonHero',
                            child: NeumorPhismContainer(
                              width: ScreenUtil().setWidth(130),
                              height: ScreenUtil().setWidth(130),
                              backgroundColor: AppColor.NavigateButton,
                              backgroundDarkerColor: AppColor.Background,
                              child: Icon(
                                Icons.menu,
                                size: ScreenUtil().setSp(50),
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      (state.playlistSongs != null || state.playlistSongs?.length > 0) ?
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: ListView.builder(
                            itemCount: state.playlistSongs?.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (state.playlistSongs[index].id ==
                                  state.currentPlaying?.id) {
                                return ChoosenSongWidget(
                                  pl: widget.pl,
                                  isFavPage: true,
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
                                  song: state.playlistSongs[index],
                                );
                              } else {
                                return SongWidget(
                                  pl: widget.pl,
                                  isFavPage: true,
                                  song: state.playlistSongs[index],
                                  onPressPlay: (SongInfo song) {
                                    playerBloc.add(
                                      PlaySong(song: song),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ):Container(
                        child:Center(
                          child: Text('No Favorites Found'),
                        )
                      ),
                    ],
                  ),
                ),
              );
            }
          ,
        ),),);
  }
}
