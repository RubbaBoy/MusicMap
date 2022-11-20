import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:music_map/service_locator.dart';
import 'package:music_map/services/spotify_service.dart';
import 'package:music_map/ui/views/home_view.dart';
import 'package:music_map/ui/views/user_map_view.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

void main() {
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final spotifyService = locator<SpotifyService>();

  final _memoizer = AsyncMemoizer<User>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Map',
      debugShowCheckedModeBanner: false,
      // https://github.com/flutter/flutter/issues/35826#issuecomment-559239389
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color.fromARGB(255, 217, 217, 217),
      ),
      home: HomeView(),
    );
  }
}