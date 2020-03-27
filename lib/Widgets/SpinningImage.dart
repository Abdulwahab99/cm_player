import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/AppVariables/AppColor.dart';
import 'package:flutter_music_neumorphism/Widgets/NeumophismContainer.dart';
import 'package:flutter_music_neumorphism/blocs/player_bloc.dart';

class SpinningImage extends StatefulWidget {
  final double height;
  final String path;

  const SpinningImage({
    Key key,
    @required this.height,
    this.path,
  }) : super(key: key);

  @override
  _SpinningImageState createState() => _SpinningImageState();
}

class _SpinningImageState extends State<SpinningImage>
    {
  PlayerBloc playerBloc;

  VoidCallback listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playerBloc = BlocProvider.of<PlayerBloc>(context);
    playerBloc.player.valueNotifier.addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();
    playerBloc.player.valueNotifier.removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return NeumorPhismContainer(
      width: widget.height,
      height: widget.height,
      spreadRadius: 8,
      blurRadius: 25,
      offset: 10,
      backgroundColor: AppColor.Darker,
      backgroundDarkerColor: AppColor.Darker,
      borderDarkerColor: AppColor.NavigateButton,
      borderColor: AppColor.NavigateButton,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.height / 2),
        child:
            (playerBloc.player.valueNotifier.value.getCurrrentMediaFile?.image !=
                        null &&
                    playerBloc.player.valueNotifier.value.getCurrrentMediaFile
                            ?.image !=
                        '')
                ? Image.file(
                    File(playerBloc
                        .player.valueNotifier.value.getCurrrentMediaFile?.image),
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    'https://i.ytimg.com/vi/doT10lpO1hI/maxresdefault.jpg',
                    fit: BoxFit.cover,
                  ),
      ),
    );
  }
}
