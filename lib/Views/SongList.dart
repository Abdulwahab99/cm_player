import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppData.dart';
import 'package:flutter_music_neumorphism/Models/songModel.dart';
import 'package:flutter_music_neumorphism/Widgets/ChoosenSongWidget.dart';
import 'package:flutter_music_neumorphism/Widgets/NeumophismContainer.dart';
import 'package:flutter_music_neumorphism/Widgets/SongWidget.dart';
import 'package:flutter_music_neumorphism/Widgets/SpinningImage.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///you need include this file only.
import 'package:flutter_audio_query/flutter_audio_query.dart';

class SongList extends StatefulWidget {
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  double sliderValue = 0;
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
            if (state.isAllSongsLoading) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state.allSongs == null || state.allSongs?.length == 0) {
              return Center(
                child: Text('No Song Found'),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: ListView.builder(
                            itemCount: state.allSongs?.length - 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (state.allSongs[index].id ==
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
                                  song: state.allSongs[index],
                                );
                              } else {
                                return SongWidget(
                                  song: state.allSongs[index],
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
