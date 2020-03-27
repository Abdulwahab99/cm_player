import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/Widgets/ArtistWidget.dart';
import 'package:flutter_music_neumorphism/Widgets/ChoosenSongWidget.dart';
import 'package:flutter_music_neumorphism/Widgets/SongWidget.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';

class Search extends SearchDelegate{
  PlayerBloc playerBloc;
  Search({this.playerBloc});
  @override
  List<Widget> buildActions(BuildContext context) {
   return [
   IconButton(icon:Icon(Icons.clear),onPressed: (){
     query='';
   },)
   ];
  }
  @override
  ThemeData appBarTheme(BuildContext context) {

    return ThemeData.dark();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return  IconButton(icon:Icon(Icons.arrow_back),onPressed: (){
      close(context,null);
    },);
  }




  @override
  Widget buildResults(BuildContext context) {
    playerBloc.applyFilter(query);
    return BlocBuilder<PlayerBloc,PlayerState>(
      builder:(context,state){
        return Scaffold(
          backgroundColor: AppColor.Background,
          body: Column(
            children: <Widget>[
              Expanded(
                child:state.fallSongs?.length==0?Container(child:Center(child:Text('No song found',style:TextStyle(color:Colors.white)))) : ListView.builder(
                    itemCount:state.fallSongs?.length,
                    itemBuilder: (context,index){
                      if (state.allSongs[index].id ==
                          playerBloc.state.currentPlaying?.id) {
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
                    }),
              ),
//
            ],
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    playerBloc.applyFilter(query);
    return BlocBuilder<PlayerBloc,PlayerState>(
      builder:(context,state){
        return Scaffold(
          backgroundColor: AppColor.Background,
          body: Column(
            children: <Widget>[
              Expanded(
                child:state.fallSongs?.length==0?Container(child:Center(child:Text('No song found',style:TextStyle(color:Colors.white)))) : ListView.builder(
                    itemCount:state.fallSongs?.length,
                    itemBuilder: (context,index){
                      if (state.fallSongs[index].id ==
                          playerBloc.state.currentPlaying?.id) {
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
                          song: state.fallSongs[index],
                        );
                      } else {
                        return SongWidget(
                          song: state.fallSongs[index],
                          onPressPlay: (SongInfo song) {
                            playerBloc.add(PlaySong(song: song));
                          },
                        );
                      }
                    }),
              ),
//
            ],
          ),
        );
      },
    );
  }

}