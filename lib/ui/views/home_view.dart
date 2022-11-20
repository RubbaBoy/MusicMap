import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:music_map/scoped_model/home_model.dart';
import 'package:music_map/scoped_model/map_view_model.dart';
import 'package:music_map/service_locator.dart';
import 'package:music_map/services/spotify_service.dart';
import 'package:music_map/ui/views/base_view.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      builder: (context, child, model) => Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
                Padding(
                  padding: const EdgeInsets.only(top: 80, bottom: 32),
                  child: bigButton('Log in with Spotify', () => model.login(context))
                ),
                bigButton('Register', () => model.login(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bigButton(String text, void Function() onPressed) => OutlinedButton(
    onPressed: onPressed,
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
          const Color.fromARGB(255, 129, 0, 186)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0))),
      side: MaterialStateProperty.all(const BorderSide(
        color: Colors.black,
        width: 3,
      )),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24),
      ),
    ),
  );
}
