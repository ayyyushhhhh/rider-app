import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
class Prefrences {
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static void saveRide({required Map ride}) {
    preferences!.setString(ride["rideID"], jsonEncode(ride));
  }

  static void deleteRide({required String rideID}) {
    preferences!.remove(rideID);
  }

  static Map<String, dynamic> getRide({required String rideID}) {
    String? ridePref = preferences!.getString('user');

    Map<String, dynamic> rideMap =
        jsonDecode(ridePref.toString()) as Map<String, dynamic>;
    return rideMap;
  }

  static Set<String> getAllKeys() {
    return preferences!.getKeys();
  }
}
