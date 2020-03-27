import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/Services/formater.dart';
import 'package:flutter_music_neumorphism/Services/navigationServices.dart';
import 'package:flutter_music_neumorphism/Views/PlayListSongs.dart';
import 'package:flutter_music_neumorphism/Views/VideoScreen.dart';
import 'package:flutter_music_neumorphism/Widgets/NeumophismContainer.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayListPage extends StatefulWidget {
  @override
  _AlbumListState createState() => _AlbumListState();
}

class _AlbumListState extends State<PlayListPage> {
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
        child: BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) {
            if (state.allPlaylists == null || state.allPlaylists?.length == 0) {
              return Center(
                child: Text('No playlist Found'),
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
                            itemCount: state.allPlaylists.length,
                            itemBuilder: (BuildContext context, int index) {
                              PlaylistInfo pl = state.allPlaylists[index];
                              return GestureDetector(
                                onTap: () {
//                                  var songs = await audioQuery.getSongsFromPlaylist(playlist: pl);
//                                  playerBloc.setPlayList(songs);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context){
                                      return PlaylistSongs(pl: pl,);
                                    }),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  pl.name,
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  '${pl.memberIds.length} Songs',
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
//
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  playerBloc.add(RemPlayList(pl:pl));
                                                },
                                                child: NeumorPhismContainer(
                                                  width: ScreenUtil()
                                                      .setWidth(100),
                                                  height: ScreenUtil()
                                                      .setWidth(100),
                                                  backgroundColor:
                                                      AppColor.NavigateButton,
                                                  backgroundDarkerColor:
                                                      AppColor.Brighter,
                                                  child: Icon(
                                                    Icons.delete,
                                                    size:
                                                        ScreenUtil().setSp(40),
                                                    color: Colors.grey[500],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return AddPlayListDialog(this.playerBloc);
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AddPlayListDialog extends StatelessWidget {
  PlayerBloc playerBloc;
  AddPlayListDialog(this.playerBloc);
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 150.0,
        ),
        child: Container(
          height: 150,
          child: Material(
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Add Playlist name',
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          onPressed: () {
                            if (controller.text != '') {
                              this
                                  .playerBloc
                                  .add(CreatePlayList(name: controller.text));
                              Navigator.pop(context);
                            }
                          },
                          child: Text('Save'),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
