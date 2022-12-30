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

  static void deleteRide({required Map ride}) {
    preferences!.remove(ride["rideID"]);
  }

  static void saveFirstImage({required String path}) {
    preferences!.setString("first", path);
  }

  static void saveSecondImage({required String path}) {
    preferences!.setString("second", path);
  }

  static String? getFirstImage() {
    return preferences!.getString("first");
  }

  static String? getSecondImage() {
    return preferences!.getString("second");
  }

  static void deleteImages() {
    preferences!.remove("first");
    preferences!.remove("secondcl");
  }
}
