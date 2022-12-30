import 'package:flutter/material.dart';

class RideDataWidget extends StatelessWidget {
  final String time;
  final String velocity;
  final String distance;
  const RideDataWidget(
      {super.key,
      required this.time,
      required this.velocity,
      required this.distance});

  _buildColumnWidget(
      {required String label,
      required String labelMeasurements,
      required String value}) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            labelMeasurements,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildColumnWidget(
              label: 'Time', labelMeasurements: 'HH:MM:SS', value: time),
          _buildColumnWidget(
              label: 'Distance', labelMeasurements: 'KMS', value: distance),
          _buildColumnWidget(
              label: 'Avg. Speed', labelMeasurements: 'kmph', value: velocity)
        ],
      ),
    );
  }
}
