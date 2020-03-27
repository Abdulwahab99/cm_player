import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/Views/AlbumList.dart';
import 'package:flutter_music_neumorphism/Views/ArtistList.dart';
import 'package:flutter_music_neumorphism/Views/FavoriteList.dart';
import 'package:flutter_music_neumorphism/Views/GenreList.dart';
import 'package:flutter_music_neumorphism/Views/PlayListList.dart';
import 'package:flutter_music_neumorphism/Views/Search.dart';
import 'package:flutter_music_neumorphism/Views/SongList.dart';
import 'package:flutter_music_neumorphism/Widgets/button_navigation.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  PlayerBloc playerBloc;

  @override
  void initState() {
    tabController = new TabController(length: 5, vsync: this);
    playerBloc = BlocProvider.of<PlayerBloc>(context);
    tabController.addListener(() {
      playerBloc.setActiveTab(tabController.index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor:  AppColor.Background,
        appBar: AppBar(
          backgroundColor: AppColor.Darker,
          title: Row(children: [
            Text(
              'CM Player',
            ),
          ]),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: Search(playerBloc: BlocProvider.of<PlayerBloc>(context)));
              },
            ),
          ],
          bottom: TabBar(
            indicator: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.Brighter,
                  AppColor.Brighter,
                ],
              ),
            ),
            isScrollable: true,
            controller: tabController,
            tabs: [
              Tab(
                child: Text('Songs'),
              ),
              Tab(
                child: Text(' Artists'),
              ),
              Tab(
                child: Text('Favorites'),
              ),
              Tab(
                child: Text('PlayLists'),
              ),
              Tab(
                child: Text('Albums'),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  SongList(),
                  ArtistList(),
                  FavoriteList(),
                  PlayListPage(),
                  AlbumList(),
                ],
              ),
            ),
            ButtonController(),
          ],
        ),
      ),
    );
  }
}
