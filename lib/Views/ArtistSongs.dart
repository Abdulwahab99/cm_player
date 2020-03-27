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

class ArtistSongs extends StatefulWidget {
  ArtistInfo artist;
  ArtistSongs({Key key, this.artist}) : super(key: key);

  @override
  _ArtistSongsState createState() => _ArtistSongsState();
}

class _ArtistSongsState extends State<ArtistSongs> {
  String playingSong;

  PlayerBloc playerBloc;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  initState() {
    playerBloc = BlocProvider.of<PlayerBloc>(context);
    playerBloc.setActiveTab(1);
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
            if (state.artistSongs == null || state.artistSongs?.length == 0) {
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
                              '${widget.artist.name}',
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
                            image: widget.artist.artistArtPath != null
                                ? FileImage(File(widget.artist.artistArtPath))
                                : Container(),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: ListView.builder(
                            itemCount: state.artistSongs?.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (state.artistSongs[index].id ==
                                  state.currentPlaying.id) {
                                return ChoosenSongWidget(
                                  onPressPlay: (SongInfo song) {
                                    if (!state.isPaused) {
                                      playerBloc.add(
                                        PauseSong(),
                                      );
                                    } else {
                                      playerBloc.add(
                                        PlaySong(
                                          song: song,
                                        ),
                                      );
                                    }
                                  },
                                  song: state.artistSongs[index],
                                );
                              } else {
                                return SongWidget(
                                  song: state.artistSongs[index],
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
