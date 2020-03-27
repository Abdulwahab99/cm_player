import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/Services/formater.dart';
import 'package:flutter_music_neumorphism/Widgets/NeumophismContainer.dart';
import 'package:flutter_music_neumorphism/Widgets/SpinningImage.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:media_player/media_player.dart';

class SongDetail extends StatefulWidget {
  final SongInfo song;

  const SongDetail({Key key, @required this.song}) : super(key: key);
  @override
  _SongDetailState createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  PlayerBloc playerBloc;

  VoidCallback listener;
  @override
  void initState() {
    super.initState();
    playerBloc = BlocProvider.of<PlayerBloc>(context);
    listener = (){
      setState(() {});
    };
    playerBloc.player.valueNotifier.addListener(listener);
  }

  @override
  void dispose() {
    playerBloc.player.valueNotifier.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        width: 1080, height: 2160, allowFontScaling: false);
    return Scaffold(
      backgroundColor: AppColor.Background,
      body: SafeArea(
        child: BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
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
                              'PLAYING NOW',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(40),
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
                                Icons.playlist_add,
                                size: ScreenUtil().setSp(50),
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: ScreenUtil().setHeight(90),
                      ),
                      Hero(
                        tag: 'imageHero',
                        child: SpinningImage(
                          height: ScreenUtil().setHeight(750),
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(90),
                      ),
                      Container(
                        child: Text(
                          state.currentPlaying.title,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(60),
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Text(
                        state.currentPlaying.artist,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(35),
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700]),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(90),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            formatDuration(
                              playerBloc.player.valueNotifier.value.position,
                            ),
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: ScreenUtil().setSp(35),
                            ),
                          ),
                          Spacer(),
                          Text(
                            formatDuration(
                              playerBloc.player.valueNotifier.value.duration,
                            ),
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: ScreenUtil().setSp(35)),
                          ),
                        ],
                      ),
                      VideoProgressIndicator(
                        playerBloc.player,
                        allowScrubbing: true,
                      ),
                      Container(
                        height: ScreenUtil().setHeight(90),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Hero(
                            tag:"prevBtn",
                            child: NeumorPhismContainer(
                              width: ScreenUtil().setWidth(200),
                              height: ScreenUtil().setWidth(200),
                              backgroundColor: AppColor.NavigateButton,
                              backgroundDarkerColor: AppColor.Brighter,
                              borderColor: AppColor.NavigateButton,
                              borderDarkerColor: AppColor.NavigateButton,
                              child: Icon(
                                Icons.skip_previous,
                                size: ScreenUtil().setSp(70),
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (!state.isPaused) {
                                BlocProvider.of<PlayerBloc>(context).add(
                                  PauseSong(),
                                );
                              } else {
                                BlocProvider.of<PlayerBloc>(context).add(
                                  ResumeSong(),
                                );
                              }
                            },
                            child: Hero(
                              tag: 'playButtonHero',
                              child: NeumorPhismContainer(
                                width: ScreenUtil().setWidth(150),
                                height: ScreenUtil().setWidth(150),
                                backgroundColor: AppColor.PauseButton,
                                backgroundDarkerColor: AppColor.Background,
                                borderColor: AppColor.PauseButton,
                                borderDarkerColor: !state.isPaused
                                    ? AppColor.PauseButton
                                    : null,
                                child: Icon(
                                  !state.isPaused
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: ScreenUtil().setSp(70),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<PlayerBloc>(context).add(
                                StopPlayer(),
                              );
                            },
                            child: Hero(
                              tag: 'StopButton',
                              child: NeumorPhismContainer(
                                width: ScreenUtil().setWidth(150),
                                height: ScreenUtil().setWidth(150),
                                backgroundColor: AppColor.PauseButton,
                                backgroundDarkerColor: AppColor.Background,
                                borderColor: AppColor.PauseButton,
                                child: Icon(
                                  Icons.stop,
                                  size: ScreenUtil().setSp(70),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              BlocProvider.of<PlayerBloc>(context)
                                  .add(NextSong());
                            },
                            child: Hero(
                              tag: "nextBtn",
                              child: NeumorPhismContainer(
                                width: ScreenUtil().setWidth(200),
                                height: ScreenUtil().setWidth(200),
                                backgroundColor: AppColor.NavigateButton,
                                backgroundDarkerColor: AppColor.Brighter,
                                borderColor: AppColor.NavigateButton,
                                borderDarkerColor: AppColor.NavigateButton,
                                child: Icon(
                                  Icons.skip_next,
                                  size: ScreenUtil().setSp(70),
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: state.fav.memberIds
                                            .contains(state.currentPlaying?.id)
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 40,
                                  ),
                                  onTap: () {
                                    state.fav.memberIds
                                            .contains(state.currentPlaying?.id)
                                        ? playerBloc.add(RemFromFav(
                                            song: state.currentPlaying))
                                        : playerBloc.add(
                                            AddToFav(song: state.currentPlaying));
                                  },
                                ),
                                GestureDetector(
                                  child: state.isReplay==1 ? Icon(
                                    Icons.repeat_one,
                                    color:Colors.red,
                                    size: 40,
                                  ):state.isReplay==2?Icon(
                                    Icons.repeat,
                                    color:Colors.red,
                                    size: 40,
                                  ):Icon(
                                    Icons.repeat,
                                    color:Colors.grey,
                                    size: 40,
                                  ),
                                  onTap: () {
                                   playerBloc.setReplayOne();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoProgressColors {
  VideoProgressColors({
    this.playedColor = const Color.fromRGBO(255, 0, 0, 0.7),
    this.bufferedColor = const Color.fromRGBO(50, 50, 200, 0.2),
    this.backgroundColor = const Color.fromRGBO(200, 200, 200, 0.5),
  });

  final Color playedColor;
  final Color bufferedColor;
  final Color backgroundColor;
}

class _VideoScrubber extends StatefulWidget {
  _VideoScrubber({
    @required this.child,
    @required this.controller,
  });

  final Widget child;
  final MediaPlayer controller;

  @override
  _VideoScrubberState createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<_VideoScrubber> {
  bool _controllerWasPlaying = false;

  MediaPlayer get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject();
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position =
          controller.valueNotifier.value.duration * relative;
      controller.seek(position.inMilliseconds);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.valueNotifier.value.initialized) {
          return;
        }
        _controllerWasPlaying = controller.valueNotifier.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.valueNotifier.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying) {
          controller.play();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.valueNotifier.value.initialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
    );
  }
}

/// Displays the play/buffering status of the video controlled by [controller].
///
/// If [allowScrubbing] is true, this widget will detect taps and drags and
/// seek the video accordingly.
///
/// [padding] allows to specify some extra padding around the progress indicator
/// that will also detect the gestures.
class VideoProgressIndicator extends StatefulWidget {
  VideoProgressIndicator(
    this.controller, {
    VideoProgressColors colors,
    this.allowScrubbing,
    this.padding = const EdgeInsets.only(top: 5.0),
  }) : colors = colors ?? VideoProgressColors();

  final MediaPlayer controller;
  final VideoProgressColors colors;
  final bool allowScrubbing;
  final EdgeInsets padding;

  @override
  _VideoProgressIndicatorState createState() => _VideoProgressIndicatorState();
}

class _VideoProgressIndicatorState extends State<VideoProgressIndicator> {
  _VideoProgressIndicatorState() {
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
  }

  VoidCallback listener;

  MediaPlayer get controller => widget.controller;
  VideoProgressColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    controller.valueNotifier.addListener(listener);
  }

  @override
  void deactivate() {
    controller.valueNotifier.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    Widget progressIndicator;
    if (controller.valueNotifier.value.initialized) {
      final int duration =
          controller.valueNotifier.value.duration.inMilliseconds;
      final int position =
          controller.valueNotifier.value.position.inMilliseconds;

      int maxBuffering = 0;
      for (DurationRange range in controller.valueNotifier.value.buffered) {
        final int end = range.end.inMilliseconds;
        if (end > maxBuffering) {
          maxBuffering = end;
        }
      }

      progressIndicator = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          LinearProgressIndicator(
            value: maxBuffering / duration,
            valueColor: AlwaysStoppedAnimation<Color>(colors.bufferedColor),
            backgroundColor: colors.backgroundColor,
          ),
          LinearProgressIndicator(
            value: position / duration,
            valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
            backgroundColor: Colors.transparent,
          ),
        ],
      );
    } else {
      progressIndicator = LinearProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(colors.playedColor),
        backgroundColor: colors.backgroundColor,
      );
    }
    final Widget paddedProgressIndicator = Padding(
      padding: widget.padding,
      child: progressIndicator,
    );
    if (widget.allowScrubbing) {
      return _VideoScrubber(
        child: paddedProgressIndicator,
        controller: controller,
      );
    } else {
      return paddedProgressIndicator;
    }
  }
}
