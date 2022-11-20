import 'package:flutter/material.dart';
import 'package:music_map/scoped_model/base_model.dart';
import 'package:music_map/scoped_model/map_view_model.dart';
import 'package:music_map/service_locator.dart';
import 'package:music_map/services/spotify_service.dart';
import 'package:music_map/ui/views/user_map_view.dart';
import 'package:music_map/utils/nav_utils.dart';

class HomeModel extends BaseModel {
  final spotifyService = locator<SpotifyService>();

  Future<void> login(BuildContext context) async {
    await spotifyService.login();
    spotifyService.startStreams();

    navTo(context, (_) => UserMapView());
  }
}
