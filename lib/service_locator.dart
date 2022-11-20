import 'package:get_it/get_it.dart';
import 'package:music_map/scoped_model/friends_model.dart';
import 'package:music_map/scoped_model/home_model.dart';
import 'package:music_map/scoped_model/locations_model.dart';
import 'package:music_map/scoped_model/map_view_model.dart';
import 'package:music_map/services/location_service.dart';
import 'package:music_map/services/request_service.dart';
import 'package:music_map/services/spotify_service.dart';
import 'package:music_map/ui/views/locations_view.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => SpotifyService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => RequestService());

  locator.registerFactory(() => MapViewModel());
  locator.registerFactory(() => HomeModel());
  locator.registerFactory(() => FriendsModel());
  locator.registerFactory(() => LocationsModel());
}
