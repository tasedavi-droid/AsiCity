import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getPosition() async {
    await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition();
  }
}