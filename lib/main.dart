import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_music_neumorphism/Services/navigationServices.dart';
import 'package:flutter_music_neumorphism/Services/router.dart';
import 'package:flutter_music_neumorphism/Services/routes.dart';
import 'package:flutter_music_neumorphism/simple_bloc_delegate.dart';

import 'blocs/player_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(BlocProvider(
    create: (context) => PlayerBloc()..add(AppStarted()),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //this is what you want
        fontFamily: 'Ubuntu',
        accentColor: Colors.grey[800],
      ),
      onGenerateRoute: generateRoute,
      navigatorKey: navigatorKey,
      initialRoute: Routes.Home,
    );
  }
}
