import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:music_map/scoped_model/friends_model.dart';
import 'package:music_map/scoped_model/home_model.dart';
import 'package:music_map/scoped_model/map_view_model.dart';
import 'package:music_map/service_locator.dart';
import 'package:music_map/services/request_service.dart';
import 'package:music_map/services/spotify_service.dart';
import 'package:music_map/ui/views/base_view.dart';
import 'package:music_map/ui/views/locations_view.dart';
import 'package:music_map/ui/views/user_map_view.dart';
import 'package:music_map/utils/nav_utils.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class FriendsView extends StatefulWidget {
  const FriendsView({Key? key}) : super(key: key);

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<FriendsModel>(
      onModelReady: (model) => model.initFriends(),
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
                        'Friends',
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
                                Icons.pin_drop,
                                size: 48,
                              ),
                              onPressed: () =>
                                  navTo(context, (_) => LocationsView()),
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
                      onSubmitted: (_) => model.addFriend(context),
                      decoration: InputDecoration(
                        hintText: 'Friend\'s name',
                        border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => model.addFriend(context),
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
                            ...model.friendRequests.map((name) =>
                                displayFriendRequest(context, model, name)),
                            const Divider(),
                            ...model.friends.map(displayFriend),
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

  Widget displayFriend(Friend friend) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundImage: NetworkImage(friend.avatar),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(friend.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${friend.song.name} - ${friend.song.artist}'),
              ],
            ),
          ],
        ),
      );

  Widget displayFriendRequest(
          BuildContext context, FriendsModel model, FriendRequest friendRequest) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(friendRequest.avatar),
                ),
              ),
              Text(friendRequest.username, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: () => model.denyFriend(context, friendRequest.username),
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () => model.acceptFriend(context, friendRequest.username),
                icon: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
              ),
            ],
        ),
      );
}
