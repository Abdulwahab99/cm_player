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

class SongWidget extends StatelessWidget {
  final Function onPressPlay;
  final SongInfo song;
  final isFavPage;
  final PlaylistInfo pl;
  const SongWidget({
    Key key,
    this.song,
    this.onPressPlay,
    this.isFavPage = false,
    this.pl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressPlay(song);
        navigatorKey.currentState
            .pushNamed(Routes.SongDetail, arguments: {'song': song});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: ListTile(
          leading: this.isFavPage || this.pl != null
              ? GestureDetector(
                  onTap: () {
                    if(this.pl==null){
                      BlocProvider.of<PlayerBloc>(context)
                          .add(RemFromFav(song: this.song));
                    }else{
                      BlocProvider.of<PlayerBloc>(context)
                          .add(RemFromPlayList(song: this.song,pl:this.pl));
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
            song.title,
            style: TextStyle(color: Colors.grey[500], fontSize: 18),
          ),
          subtitle: Row(
            children: <Widget>[
              Expanded(
                child: Text(song.artist,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    overflow: TextOverflow.ellipsis),
              ),
              Text(
                  formatDuration(
                      Duration(milliseconds: int.parse(song.duration))),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          trailing: GestureDetector(
            onTap: () {
              onPressPlay(song);
            },
            child: NeumorPhismContainer(
              width: ScreenUtil().setWidth(100),
              height: ScreenUtil().setWidth(100),
              backgroundColor: AppColor.NavigateButton,
              backgroundDarkerColor: AppColor.Brighter,
              child: Icon(
                Icons.play_arrow,
                size: ScreenUtil().setSp(40),
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
