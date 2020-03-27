import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/Services/formater.dart';
import 'package:flutter_music_neumorphism/Services/navigationServices.dart';
import 'package:flutter_music_neumorphism/Services/routes.dart';
import 'package:flutter_music_neumorphism/Widgets/NeumophismContainer.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChoosenSongWidget extends StatefulWidget {
  final Function onPressPlay;
  final SongInfo song;
  final isFavPage;
  final PlaylistInfo pl;
  const ChoosenSongWidget({
    Key key,
    this.song,
    this.isFavPage = false,
    this.onPressPlay,
    this.pl,
  }) : super(key: key);

  @override
  _ChoosenSongWidgetState createState() => _ChoosenSongWidgetState();
}

class _ChoosenSongWidgetState extends State<ChoosenSongWidget> {
  PlayerBloc playerBloc;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    playerBloc = BlocProvider.of<PlayerBloc>(context);
    listener = () {
      if (!mounted) {
        return;
      }
      setState(() {});
    };
    playerBloc.player.valueNotifier.addListener(listener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerBloc.player.valueNotifier.removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // widget.onPressPlay(widget.song);
        navigatorKey.currentState
            .pushNamed(Routes.SongDetail, arguments: {'song': widget.song});
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setSp(15),
            vertical: ScreenUtil().setSp(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppColor.NavigateButton,
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
        child: ListTile(
          leading: widget.isFavPage || widget.pl!=null
              ? GestureDetector(
                  onTap: () {
                    if(widget.pl==null){
                      BlocProvider.of<PlayerBloc>(context)
                          .add(RemFromFav(song: widget.song));
                    }else{
                      BlocProvider.of<PlayerBloc>(context)
                          .add(RemFromPlayList(song: widget.song,pl:widget.pl));
                    }
                  },
                  child: NeumorPhismContainer(
                    width: ScreenUtil().setWidth(100),
                    height: ScreenUtil().setWidth(100),
                    backgroundColor: AppColor.NavigateButton,
                    backgroundDarkerColor: AppColor.Brighter,
                    child: Icon(
                      Icons.delete,
                      size: ScreenUtil().setSp(40),
                      color: Colors.grey[500],
                    ),
                  ),
                )
              : null,
          title: Text(
              widget.song.title,
              style: TextStyle(color: Colors.grey[500], fontSize: 18),
              ),
          subtitle: Row(
            children: <Widget>[
              Text(
                widget.song.artist,
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
              Spacer(),
              Text(
                formatDuration(
                  playerBloc.player.valueNotifier.value.position,
                ),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700], fontSize: 15),
              ),
            ],
          ),
          trailing: GestureDetector(
            onTap: () {
              widget.onPressPlay(widget.song);
            },
            child: Hero(
              tag: 'playButtonHero',
              child: NeumorPhismContainer(
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setWidth(100),
                backgroundColor: AppColor.PauseButton,
                backgroundDarkerColor: AppColor.PauseButtonDarker,
                borderColor: AppColor.PauseButton,
                borderDarkerColor: AppColor.PauseButton,
                child: Icon(
                  playerBloc.state.isPaused ? Icons.play_arrow : Icons.pause,
                  size: ScreenUtil().setSp(40),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
