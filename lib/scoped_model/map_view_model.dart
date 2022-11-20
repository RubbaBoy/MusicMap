import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:label_marker/label_marker.dart';
import 'package:music_map/asset_utils.dart';
import 'package:music_map/enums/view_states.dart';
import 'package:music_map/scoped_model/base_model.dart';
import 'package:music_map/service_locator.dart';
import 'package:music_map/services/location_service.dart';
import 'package:music_map/services/request_service.dart';
import 'package:music_map/utils/icon_utils.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

typedef BottomSheet = void Function(MapViewModel, BuildContext, UserPlaying);

class MapViewModel extends BaseModel {
  final locationService = locator<LocationService>();
  final requestService = locator<RequestService>();
  late Uint8List pinIcon;
  late BottomSheet bottomSheet;

  GoogleMapController? controller;
  Position? position;
  Set<Marker> markers = {};

  Future<void> init(BottomSheet showBottomSheet, BuildContext context) async {
    print('${DateTime.now()} === init(*)()()');
    setState(ViewState.Busy);

    bottomSheet = showBottomSheet;
    pinIcon = await getBytesFromAsset('assets/pin.png', 100);

    locationService.determinePosition().then((position) {
      this.position = position;
      setState(ViewState.Ok);
    });

    requestService.getAllPlaying().then((users) async {
      print('${DateTime.now()} === users = ${users.length}');
      var markers = <Marker>{};

      for (var user in users) {
        var iconWithText = await getBytesFromCanvas('${user.song.name} - ${user.song.artist}', pinIcon);
        var icon = BitmapDescriptor.fromBytes(iconWithText);

        markers.add(Marker(
          markerId: MarkerId('${user.location.hashCode}-${user.song.hashCode}'),
          position: LatLng(user.location.latitude, user.location.longitude),
          icon: icon,
          onTap: () => bottomSheet(this, context, user),
        ));
      }

      this.markers = markers;
      notifyListeners();
    });
  }

  void onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }
}
