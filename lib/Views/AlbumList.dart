import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/Widgets/AlbumWidget.dart';
import 'package:flutter_music_neumorphism/Widgets/ArtistWidget.dart';
import 'package:flutter_music_neumorphism/Widgets/ChoosenSongWidget.dart';
import 'package:flutter_music_neumorphism/Widgets/NeumophismContainer.dart';
import 'package:flutter_music_neumorphism/Widgets/SongWidget.dart';
import 'package:flutter_music_neumorphism/Widgets/SpinningImage.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlbumList extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
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
        body: SafeArea(child: BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) {
            if (state.allAlbums == null || state.allAlbums?.length == 0) {
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
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: state.allAlbums?.length - 1,
                            itemBuilder: (BuildContext context, int index) {
                              return AlbumWidget(
                                album: state.allAlbums[index],
                                onPressPlay: () {},
                              );
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
