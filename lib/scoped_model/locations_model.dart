import 'package:flutter/material.dart';
import 'package:music_map/scoped_model/base_model.dart';
import 'package:music_map/service_locator.dart';
import 'package:music_map/services/request_service.dart';
import 'package:music_map/services/spotify_service.dart';

class LocationsModel extends BaseModel {
  final requestService = locator<RequestService>();
  final spotifyService = locator<SpotifyService>();

  final TextEditingController inputController = TextEditingController();

  FollowedLocation? searchedLocation;
  List<String> followedLocations = [];

  void initLocations() {
    print('HERE');
    requestService
        .getFollowedLocations(spotifyService.username)
        .then((followedLocations) {
      this.followedLocations = followedLocations;
      notifyListeners();
    });
  }

  void end() {
    inputController.dispose();
  }

  void followLocation(BuildContext context, String city) {
    print('followLocation');
    searchedLocation = null;
    requestService
        .followLocation(spotifyService.username, city)
        .then((_) => Future.delayed(const Duration(milliseconds: 1000), () => initLocations()));

    sendToast(context, 'Started following $city');
  }

  void searchCity() {
    var city = inputController.value.text;
    inputController.clear();
    requestService.getLocation(city).then((location) {
      searchedLocation = location;
    });
  }

  void clearSearched() {
    inputController.clear();
    searchedLocation = null;
  }

  void clickLocation(BuildContext context, LocationsModel model, String city, void Function(LocationsModel, BuildContext, FollowedLocation) builder) {
    requestService.getLocation(city).then((followedLocation) {
      if (followedLocation != null) {
        builder(this, context, followedLocation);
      }
    });
  }

  void sendToast(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(name),
    ));
  }
}
