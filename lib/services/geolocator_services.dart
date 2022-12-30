import 'package:geolocator/geolocator.dart';

class GeolocatorService {
  final Geolocator geo = Geolocator();
  late Stream<Position> _positionSteam;

  Stream<Position> getCurrentLocation() {
    var locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionSteam =
        Geolocator.getPositionStream(locationSettings: locationSettings);
    return _positionSteam;
  }

  // void disposeStream() {
  //   _positionSteam.cancel();
  // }

  Future<Position> getInitialLocation() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  double getDistance(
      {required lat1, required lon1, required lat2, required lon2}) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}
