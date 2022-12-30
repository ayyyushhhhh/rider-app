import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rider_app/Models/rider_model.dart';
import 'package:rider_app/screens/main_screen.dart';
import 'package:rider_app/services/firebase/cloud_databse.dart';

class RideInfoScreen extends StatelessWidget {
  final RideModel rideModel;
  const RideInfoScreen({super.key, required this.rideModel});

  _uploadRide(BuildContext context) {
    final CloudDatabase cloudDatabase = CloudDatabase();
    try {
      cloudDatabase.uploadProductData(rideModel.toMap());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (Route<dynamic> route) => false);
    } catch (e) {}
  }

  _buildColumnWidget({required String label, required String value}) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          Column(
            children: [
              const Center(
                child: Text(
                  "Ride Information",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildColumnWidget(
                        label: "Start Time",
                        value: DateFormat('d MMM yy, hh:mm aaa ')
                            .format(rideModel.startTime!),
                      ),
                      _buildColumnWidget(
                        label: "Finish Time",
                        value: DateFormat('d MMM yy, hh:mm aaa ')
                            .format(rideModel.finishTime!),
                      ),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildColumnWidget(
                        label: "Time", value: rideModel.time.toString()),
                    _buildColumnWidget(
                        label: "Distance",
                        value: rideModel.distance.toString()),
                    _buildColumnWidget(
                        label: "Avg Speed",
                        value: rideModel.avgSpeed.toString()),
                  ],
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              _uploadRide(context);
            },
            child: Container(
              height: 40,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
              child: const Center(
                child: Text(
                  "Save Info",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
