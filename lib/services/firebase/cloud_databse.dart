import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_app/utils/shared_prefrences.dart';

class CloudDatabase {
  late FirebaseFirestore _firestore;
  // ignore: non_constant_identifier_names
  CloudDatabase() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> uploadProductData(Map<String, dynamic> ride) async {
    Prefrences.saveRide(ride: ride);
    final String productpath = "Rides/${ride["rideID"]}";

    try {
      final DocumentReference<Map<String, dynamic>> cloudRef =
          _firestore.doc(productpath);
      await cloudRef.set(ride);
      Prefrences.deleteRide(ride: ride);
    } on FirebaseException {
      rethrow;
    }
  }
}
