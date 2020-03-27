import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/Widgets/NeumophismContainer.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:media_player/ui.dart';

import 'SpinningImage.dart';

class ButtonController extends StatefulWidget {
  @override
  _ButtonControllerState createState() => _ButtonControllerState();
}

class _ButtonControllerState extends State<ButtonController> {
  PlayerBloc playerBloc;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    playerBloc = BlocProvider.of<PlayerBloc>(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1080, height: 2160, allowFontScaling: false);
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(bottom: 0, left: 10,right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: AppColor.Darker,
            boxShadow: [
              BoxShadow(
                  color: AppColor.Darker,
                  offset: Offset(0.5, 0.5),
                  blurRadius: 1,
                  spreadRadius: 0.5),
              BoxShadow(
                  color: AppColor.Brighter,
                  offset: Offset(-0.5, -0.5),
                  blurRadius: 1,
                  spreadRadius: 0.5),
            ],
          ),
          child: Stack(
              children:[

            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: 'imageHero',
                    child: SpinningImage(
                      height: ScreenUtil().setHeight(150),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        state.currentPlaying!=null ?Marquee(child: Text(state.currentPlaying?.title,style: TextStyle(color:Colors.white),),):Container(),
                        state.currentPlaying!=null ?Marquee(child: Text(state.currentPlaying?.artist,style: TextStyle(color:Colors.white,fontSize: 12),)):Container(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            playerBloc.add(PreviousSong());
                          },
                          child: Hero(
                            tag: 'prevBtn',
                            child: NeumorPhismContainer(
                              width: 35,
                              height: 35,
                              backgroundColor: AppColor.PauseButton,
                              backgroundDarkerColor: AppColor.PauseButtonDarker,
                              borderColor: AppColor.PauseButton,
                              borderDarkerColor: AppColor.PauseButton,
                              child: Icon(
                                Icons.skip_previous,
                                size: ScreenUtil().setSp(40),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (state.isPaused) {
                              playerBloc.add(ResumeSong());
                            } else {
                              playerBloc.add(PauseSong());
                            }
                          },
                          child: Hero(
                            tag: 'serer',
                            child: NeumorPhismContainer(
                              width: ScreenUtil().setWidth(150),
                              height: ScreenUtil().setWidth(150),
                              backgroundColor: AppColor.PauseButton,
                              backgroundDarkerColor: AppColor.PauseButtonDarker,
                              borderColor: AppColor.PauseButton,
                              borderDarkerColor:
                              !state.isPaused ? AppColor.PauseButton : null,
                              child: Icon(
                                state.isPaused ? Icons.play_arrow : Icons.pause,
                                size: ScreenUtil().setSp(40),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            playerBloc.add(NextSong());
                          },
                          child: Hero(
                            tag: 'nextBtn',
                            child: NeumorPhismContainer(
                              width: ScreenUtil().setWidth(100),
                              height: ScreenUtil().setWidth(100),
                              backgroundColor: AppColor.PauseButton,
                              backgroundDarkerColor: AppColor.PauseButtonDarker,
                              borderColor: AppColor.PauseButton,
                              borderDarkerColor: AppColor.PauseButton,
                              child: Icon(
                                Icons.skip_next,
                                size: ScreenUtil().setSp(40),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
                Positioned(child:Container(
                  height: 2,
                  child: VideoProgressIndicator(
                    playerBloc.player,
                    allowScrubbing: true,
                    padding: EdgeInsets.zero,
                  ),
                ),),
          ]),


        );
      },
    );
  }
}
