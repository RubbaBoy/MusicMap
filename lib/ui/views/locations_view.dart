import 'package:flutter/material.dart';
import 'package:music_map/scoped_model/locations_model.dart';
import 'package:music_map/services/request_service.dart';
import 'package:music_map/ui/views/base_view.dart';
import 'package:music_map/ui/views/friends_view.dart';
import 'package:music_map/ui/views/user_map_view.dart';
import 'package:music_map/utils/nav_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LocationsView extends StatefulWidget {
  const LocationsView({Key? key}) : super(key: key);

  @override
  State<LocationsView> createState() => _LocationsViewState();
}

class _LocationsViewState extends State<LocationsView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<LocationsModel>(
      onModelReady: (model) => model.initLocations(),
      onModelEnd: (model) => model.end(),
      builder: (context, child, model) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subscribed\nCities',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.map_outlined,
                              size: 48,
                            ),
                            onPressed: () =>
                                navTo(context, (_) => UserMapView()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: IconButton(
                              icon: const Icon(
                                Icons.person_add,
                                size: 48,
                              ),
                              onPressed: () =>
                                  navTo(context, (_) => FriendsView()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: TextField(
                      controller: model.inputController,
                      onSubmitted: (_) => model.searchCity(),
                      decoration: InputDecoration(
                        hintText: 'Find Your City',
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => model.searchCity(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (model.searchedLocation != null)
                              displaySearchedLocation(
                                  context, model, model.searchedLocation!),
                            const Divider(),
                            ...model.followedLocations.map((followedLocation) =>
                                displayFollowedLocation(
                                    context, model, followedLocation)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displaySearchedLocation(BuildContext context, LocationsModel model,
          FollowedLocation followedLocation) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(followedLocation.city,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    '${followedLocation.song.name} - ${followedLocation.song.artist}'),
                Text(followedLocation.song.genre),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () => model.clearSearched(),
              icon: const Icon(
                Icons.clear,
                color: Colors.red,
              ),
            ),
            IconButton(
              onPressed: () =>
                  model.followLocation(context, followedLocation.city),
              icon: const Icon(
                Icons.add,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );

  Widget displayFollowedLocation(BuildContext context, LocationsModel model,
          String followedLocation) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: InkWell(
              child: GestureDetector(
                onTap: () => model.clickLocation(
                    context, model, followedLocation, showBottomSheet),
                child: Text(
                  followedLocation,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      );

  void showBottomSheet(
          LocationsModel model, BuildContext context, FollowedLocation followedLocation) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 275,
            // color: Colors.amber,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                followedLocation.city,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              OutlinedButton(
                                onPressed: () => model.followLocation(context, followedLocation.city),
                                child: Text('Follow'),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.pin_drop,
                            size: 45,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8),
                                  child: Text('Top Song:',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24)),
                                ),
                                Text(
                                  followedLocation.song.name,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  followedLocation.song.artist,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => launchUrlString(
                                  'spotify:track:${followedLocation.song.id}',
                                  mode: LaunchMode.externalApplication),
                              child: Icon(
                                Icons.play_arrow,
                                size: 45,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Top Genre:',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24)),
                              Text(
                                followedLocation.genre,
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
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
