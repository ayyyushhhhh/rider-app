// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class RideModel {
  String rideID;
  List<String>? imagePaths;
  DateTime? startTime;
  DateTime? finishTime;
  String? time;
  String? distance;
  String? avgSpeed;
  List<double>? startpoint;
  List<double>? finishPoint;

  RideModel({
    required this.rideID,
    this.imagePaths,
    this.startTime,
    this.finishTime,
    this.time,
    this.distance,
    this.avgSpeed,
    this.startpoint,
    this.finishPoint,
  });

  RideModel copyWith({
    String? rideID,
    List<String>? imagePaths,
    DateTime? startTime,
    DateTime? finishTime,
    String? time,
    String? distance,
    String? avgSpeed,
    List<double>? startpoint,
    List<double>? finishPoint,
  }) {
    return RideModel(
      rideID: rideID ?? this.rideID,
      imagePaths: imagePaths ?? this.imagePaths,
      startTime: startTime ?? this.startTime,
      finishTime: finishTime ?? this.finishTime,
      time: time ?? this.time,
      distance: distance ?? this.distance,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      startpoint: startpoint ?? this.startpoint,
      finishPoint: finishPoint ?? this.finishPoint,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rideID': rideID,
      'imagePaths': imagePaths,
      'startTime': startTime?.millisecondsSinceEpoch,
      'finishTime': finishTime?.millisecondsSinceEpoch,
      'time': time,
      'distance': distance,
      'avgSpeed': avgSpeed,
      'startpoint': startpoint,
      'finishPoint': finishPoint,
    };
  }

  factory RideModel.fromMap(Map<String, dynamic> map) {
    return RideModel(
      rideID: map['rideID'] as String,
      imagePaths: map['imagePaths'] != null
          ? List<String>.from(map['imagePaths'] as List<String>)
          : null,
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int)
          : null,
      finishTime: map['finishTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['finishTime'] as int)
          : null,
      time: map['time'] != null ? map['time'] as String : null,
      distance: map['distance'] != null ? map['distance'] as String : null,
      avgSpeed: map['avgSpeed'] != null ? map['avgSpeed'] as String : null,
      startpoint: map['startpoint'] != null
          ? List<double>.from(map['startpoint'] as List<double>)
          : null,
      finishPoint: map['finishPoint'] != null
          ? List<double>.from(map['finishPoint'] as List<double>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RideModel.fromJson(String source) =>
      RideModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RideModel(rideID: $rideID, imagePaths: $imagePaths, startTime: $startTime, finishTime: $finishTime, time: $time, distance: $distance, avgSpeed: $avgSpeed, startpoint: $startpoint, finishPoint: $finishPoint)';
  }

  @override
  bool operator ==(covariant RideModel other) {
    if (identical(this, other)) return true;

    return other.rideID == rideID &&
        listEquals(other.imagePaths, imagePaths) &&
        other.startTime == startTime &&
        other.finishTime == finishTime &&
        other.time == time &&
        other.distance == distance &&
        other.avgSpeed == avgSpeed &&
        listEquals(other.startpoint, startpoint) &&
        listEquals(other.finishPoint, finishPoint);
  }

  @override
  int get hashCode {
    return rideID.hashCode ^
        imagePaths.hashCode ^
        startTime.hashCode ^
        finishTime.hashCode ^
        time.hashCode ^
        distance.hashCode ^
        avgSpeed.hashCode ^
        startpoint.hashCode ^
        finishPoint.hashCode;
  }
}
