import 'dart:io';
import 'package:music_map/service_locator.dart';
import 'package:music_map/services/location_service.dart';
import 'package:music_map/services/request_service.dart';

import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

const clientId = '2a42e5eab2554e9dba3daf8a25183b11';

class SpotifyService {
  final locationService = locator<LocationService>();
  final requestService = locator<RequestService>();

  late SpotifyApi api;
  late User me;
  late String username;

  Future<User> login() async {
    await SpotifySdk.connectToSpotifyRemote(clientId: clientId, redirectUrl: "http://localhost/", scope: 'app-remote-control, '
        'user-modify-playback-state, '
        'playlist-read-private, '
        'playlist-modify-public,user-read-currently-playing');

    var accessToken = await SpotifySdk.getAccessToken(
        clientId: clientId,
        redirectUrl: "http://localhost/",
        scope: 'app-remote-control, '
            'user-modify-playback-state, '
            'playlist-read-private, '
            'playlist-modify-public,user-read-currently-playing');

    var credentials = oauth2.Credentials(accessToken,
        refreshToken: '',
        tokenEndpoint: Uri.parse('https://accounts.spotify.com/api/token'));

    var client = oauth2.Client(
      credentials,
      identifier: clientId,
    );

    api = SpotifyApi.fromClient(client);
    me = await api.me.get();

    if (me.displayName == null) {
      throw 'Could not find displayName';
    }

    username = me.displayName!;

    // print(me.images?.first.url);

    requestService.login(me.displayName ?? '', me.images?.first.url ?? '');

    return me;
  }

  void startStreams() {
    SpotifySdk.subscribePlayerState().listen((event) async {
      var loc = await locationService.determinePosition();
      print('Updating song: ${event.track?.name} at: (${loc.latitude}, ${loc.longitude})');
      if (me.displayName == null || event.track == null) {
        print('Something is null!');
        return;
      }

      requestService.updateNowPlaying(me.displayName!, event.track!, loc);
    });
  }
}
