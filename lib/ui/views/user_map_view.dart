import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:music_map/scoped_model/map_view_model.dart';
import 'package:music_map/service_locator.dart';
import 'package:music_map/services/request_service.dart';
import 'package:music_map/services/spotify_service.dart';
import 'package:music_map/ui/views/base_view.dart';
import 'package:music_map/ui/views/friends_view.dart';
import 'package:music_map/ui/views/locations_view.dart';
import 'package:music_map/utils/nav_utils.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserMapView extends StatefulWidget {
  @override
  _UserMapViewState createState() => _UserMapViewState();
}

class _UserMapViewState extends State<UserMapView> {
  final service = locator<SpotifyService>();

  @override
  Widget build(BuildContext context) => BaseView<MapViewModel>(
        onModelReady: (model) => model.init(showBottomSheet, context),
        builder: (context, child, model) => Stack(
          children: [
            GoogleMap(
              key: GlobalKey(),
              mapToolbarEnabled: false,
              compassEnabled: false,
              onMapCreated: model.onMapCreated,
              markers: model.markers.toSet(),
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(model.position!.latitude, model.position!.longitude),
                zoom: 10.0,
              ),
            ),
            Positioned(
              key: GlobalKey(),
              top: 25,
              left: 25,
              child: ElevatedButton(
                onPressed: () => navTo(context, (_) => FriendsView()),
                child: const Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 30,
                ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.blue, // <-- Button color
                  foregroundColor: Colors.red, // <-- Splash color
                ),
              ),
            ),
            Positioned(
              key: GlobalKey(),
              top: 25,
              right: 25,
              child: ElevatedButton(
                onPressed: () => navTo(context, (_) => LocationsView()),
                child: const Icon(
                  Icons.pin_drop,
                  color: Colors.white,
                  size: 30,
                ),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.blue, // <-- Button color
                  foregroundColor: Colors.red, // <-- Splash color
                ),
              ),
            ),
          ],
        ),
      );

  void showBottomSheet(
      MapViewModel model, BuildContext context, UserPlaying userPlaying) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 75,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userPlaying.song.name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userPlaying.song.artist,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: GestureDetector(
                        onTap: () {
                          print('spotify:track:${userPlaying.song.id}');
                          launchUrlString(
                            'spotify:track:${userPlaying.song.id}',
                            mode: LaunchMode.externalApplication);
                        },
                        child: Icon(
                          Icons.play_arrow,
                          size: 45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
}
