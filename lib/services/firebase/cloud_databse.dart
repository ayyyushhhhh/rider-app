import 'package:cloud_firestore/cloud_firestore.dart';

class CloudDatabase {
  late FirebaseFirestore _firestore;
  // ignore: non_constant_identifier_names
  CloudDatabase() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> uploadRideData(Map<String, dynamic> ride) async {
    final String productpath = "Rides/${ride["rideID"]}";

    try {
      final DocumentReference<Map<String, dynamic>> cloudRef =
          _firestore.doc(productpath);
      await cloudRef.set(ride);
    } on FirebaseException {
      rethrow;
    }
  }
}
