import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/models/track.dart';

class RequestService {
  static const baseUri = 'http://172.30.0.3:5000';
  // static const baseUri = 'https://stoplight.io/mocks/adamyarris/bruh/2951998';

  /// Sends an initial request after the user connects to Spotify. This will
  /// create an "account" if one is not made already. [username] is the user
  /// requesting this, and [avatar] is the direct URL to the user's profile
  /// picture image.
  Future<void> login(String username, String avatar) async {
    print('login($username, $avatar)');

    await http
        .post(Uri.parse('$baseUri/login'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'username': username,
              'avatar': avatar,
            }))
        .then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on login(): ${response.statusCode}';
      }
    });
  }

  /// Updates the currently playing song at the user's position. [username]
  /// is the user requesting this.
  Future<void> updateNowPlaying(
      String username, Track track, Position position) async {
    print('updateNowPlaying()'); // TODO

    // return;
    // print(json.encode({
    //   'currentSongName': track.name,
    //   'currentSongGenre': 'genre', // TODO: genre
    //   'currentSongArtist': track.artists.first.name,
    //   'currentSongId': track.uri,
    //   'longitude': position.longitude,
    //   'latitude': position.latitude,
    //   'username': username,
    // }));

    await http
        .post(Uri.parse('$baseUri/playing'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'currentSongName': track.name,
              'currentSongGenre': 'genre', // TODO: genre
              'currentSongArtist': track.artists.first.name,
              'currentSongId': track.uri,
              'longitude': position.longitude,
              'latitude': position.latitude,
              'username': username,
            }))
        .then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on updateNowPlaying(): ${response.statusCode}';
      }
    });
  }

  /// Gets all people currently playing songs.
  Future<List<UserPlaying>> getAllPlaying() {
    print('getAllPlaying()');

    // return Future.value([
    //   UserPlaying(Location(43.1566, -77.6088), Song('3idDCx8VXTkqPL6UQTK4bl', 'Arcadia', 'Goose', 'Jam'))
    // ]);

    return http.get(Uri.parse('$baseUri/songs'),
        headers: {'Content-Type': 'application/json'}).then((response) {
      if (response.statusCode != 200) {
        throw 'Non-200 error code on getAllPlaying(): ${response.statusCode}';
      }

      print('body =');
      print(response.body);
      var json = jsonDecode(response.body);
      print('json =');
      print(json);
      print(json.runtimeType);
      return (json as List).map((e) => UserPlaying.fromJson(e)).toList();
    });
  }

  /// Gets all people currently playing songs. [username] is the user
  /// requesting this.
  Future<List<Friend>> getFriends(String username) {
    print('getFriends($username)');

    return http.get(Uri.parse('$baseUri/friends?username=$username'),
        headers: {'Content-Type': 'application/json'}).then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on getFriends(): ${response.statusCode}';
      }

      var json = jsonDecode(response.body) as List;
      return json.map((e) => Friend.fromJson(e)).toList();
    });
    // return Future.value([
    //   Friend(
    //       'suppermine',
    //       'https://i.scdn.co/image/ab6775700000ee8583541d6ec61029693aa01a0b',
    //       Location(0, 0),
    //       Song('3idDCx8VXTkqPL6UQTK4bl', 'Arcadia', 'Goose', 'Jam'))
    // ]);
  }

  /// Gets the top song/genres from a given location (city).
  Future<FollowedLocation?> getLocation(String city) {
    print('getDataFromLocation($city)');

    // return Future.value(FollowedLocation('Rochester', 'pop', Song('3idDCx8VXTkqPL6UQTK4bl', 'God Knows', 'Knocked Loose', 'metalcore')));
    return http.get(Uri.parse('$baseUri/location?city=$city'),
        headers: {'Content-Type': 'application/json'}).then((response) {
      if (response.statusCode == 404) {
        return null;
      }

      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on getLocation(): ${response.statusCode}';
      }

      var json = jsonDecode(response.body);
      return FollowedLocation.fromJson(json);
    });
  }

  /// Accepts a pending friend request.
  Future<void> acceptFriendRequest(String username, String friend) {
    print('acceptFriendRequest($username, $friend)');

    return http.post(Uri.parse('$baseUri/friends/accept'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode({
    'username': username,
    'friend': friend,
    })).then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on acceptFriendRequest(): ${response.statusCode}';
      }
    });
  }

  /// Denies a pending friend request.
  Future<void> denyFriendRequest(String username, String friend) {
    print('denyFriendRequest($username, $friend)');

    return http.post(Uri.parse('$baseUri/friends/deny'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode({
          'username': username,
          'friend': friend,
        })).then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on denyFriendRequest(): ${response.statusCode}';
      }
    });
  }

  /// Gets all friend requests for the user [username].
  Future<List<FriendRequest>> getFriendRequests(String username) {
    print('getFriendRequests($username)');

    // return Future.value([
    //   FriendRequest('shamfrags',
    //       'https://i.scdn.co/image/ab6775700000ee8583541d6ec61029693aa01a0b'),
    //   FriendRequest('loppolo',
    //       'https://i.scdn.co/image/ab6775700000ee8583541d6ec61029693aa01a0b')
    // ]);
    return http.get(Uri.parse('$baseUri/friends/requests?username=$username'),
        headers: {'Content-Type': 'application/json'}).then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on getFriendRequests(): ${response.statusCode}';
      }

      var json = jsonDecode(response.body) as List;
      return json.map((e) => FriendRequest.fromJson(e)).toList();
    });
  }

  /// Sends a friend request to [person].
  Future<void> sendFriendRequest(String username, String person) {
    print('getFriendRequests($username)');

    return http
        .post(Uri.parse('$baseUri/friends/requests'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'sender': username, 'receiver': person}))
        .then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on sendFriendRequest(): ${response.statusCode}';
      }
    });
  }

  /// Follows a location.
  Future<void> followLocation(String username, String location) {
    print('followLocation($username)');

    // return Future.value();
    return http
        .post(Uri.parse('$baseUri/locations/follow'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'city': location,
            }))
        .then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on followLocation(): ${response.statusCode}';
      }
    });
  }

  /// Unfollows a location.
  Future<void> unfollowLocation(String username, String location) {
    print('unfollowLocation($username)');

    // return Future.value();
    return http
        .post(Uri.parse('$baseUri/locations/unfollow'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'city': location,
            }))
        .then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on unfollowLocation(): ${response.statusCode}';
      }
    });
  }

  /// Gets all followed locations
  Future<List<String>> getFollowedLocations(String username) {
    print('getFollowedLocations($username)');

    // return Future.value(['Buffalo', 'Onita']);
    return http.get(Uri.parse('$baseUri/locations/followed?username=$username')).then((response) {
      if (response.statusCode != 200) {
        print(response.body);
        throw 'Non-200 error code on getFollowedLocations(): ${response.statusCode}';
      }

      var test = jsonDecode(response.body) as List;
      return test.map((e) => e as String).toList();
    });
  }
}

class FriendRequest {
  final String username;
  final String avatar;

  FriendRequest(this.username, this.avatar);

  FriendRequest.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        avatar = json['avatar'];
}

class Friend {
  final String name;
  final String avatar;
  final Location location;
  final Song song;

  Friend(this.name, this.avatar, this.location, this.song);

  Friend.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        avatar = json['avatar'],
        location = Location.fromJson(json['location']),
        song = Song.fromJson(json['song']);
}

class UserPlaying {
  final Location location;
  final Song song;

  UserPlaying(this.location, this.song);

  UserPlaying.fromJson(Map<String, dynamic> json)
      : location = Location.fromJson(json['location']),
        song = Song.fromJson(json['song']);
}

class Song {
  final String id;
  final String name;
  final String artist;
  final String genre;

  Song(this.id, this.name, this.artist, this.genre);

  Song.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        artist = json['artist'],
        genre = json['genre'];


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          artist == other.artist &&
          genre == other.genre;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ artist.hashCode ^ genre.hashCode;

  @override
  String toString() {
    return 'Song{id: $id, name: $name, artist: $artist, genre: $genre}';
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  Location.fromJson(Map<String, dynamic> json)
      : latitude = double.parse(json['latitude']),
        longitude = double.parse(json['longitude']);


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() {
    return 'Location{latitude: $latitude, longitude: $longitude}';
  }
}

class FollowedLocation {
  final String city;
  final String genre;
  final Song song;

  FollowedLocation(this.city, this.genre, this.song);

  FollowedLocation.fromJson(Map<String, dynamic> json)
      : city = json['city'],
        genre = json['genre'],
        song = Song.fromJson(json['song']);
}
