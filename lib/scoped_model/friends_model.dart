import 'package:flutter/material.dart';
import 'package:music_map/scoped_model/base_model.dart';
import 'package:music_map/service_locator.dart';
import 'package:music_map/services/request_service.dart';
import 'package:music_map/services/spotify_service.dart';

class FriendsModel extends BaseModel {
  final requestService = locator<RequestService>();
  final spotifyService = locator<SpotifyService>();

  final TextEditingController inputController = TextEditingController();

  List<Friend> friends = [];
  List<FriendRequest> friendRequests = [];

  void initFriends() {
    requestService.getFriends(spotifyService.username).then((friends) {
      this.friends = friends;
      notifyListeners();
    });

    requestService.getFriendRequests(spotifyService.username).then((friendRequests) {
      print(friendRequests);
      this.friendRequests = friendRequests;
      notifyListeners();
    });
  }

  void end() {
    inputController.dispose();
  }

  void addFriend(BuildContext context) {
    print('addFriend');
    var friend = inputController.value.text;
    inputController.clear();

    requestService.sendFriendRequest(
        spotifyService.username, friend);

    sendToast(context, 'Sent a friend request to $friend');
  }

  void denyFriend(BuildContext context, String name) {
    requestService.denyFriendRequest(spotifyService.username, name);
    sendToast(context, 'Denied $name\'s friend request');
    Future.delayed(const Duration(milliseconds: 500), () {
      initFriends();
    });
  }

  void acceptFriend(BuildContext context, String name) {
    requestService.acceptFriendRequest(spotifyService.username, name);
    sendToast(context, 'Accepted $name\'s friend request');
    Future.delayed(const Duration(milliseconds: 1000), () {
      initFriends();
    });
  }

  void sendToast(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(name),
    ));
  }
}
