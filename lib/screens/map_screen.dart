import 'dart:async';

import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Models/rider_model.dart';
import 'package:rider_app/screens/camera_screen.dart';
import 'package:rider_app/services/geolocator_services.dart';
import 'package:rider_app/services/stop_watch_data.dart';
import 'package:rider_app/widgets/ride_data_widget.dart';
import 'package:rider_app/widgets/slide_action.dart';
import '../utils/app_constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late DateTime startTime;
  MapController mapController = MapController();
  double velocity = 0;
  double distance = 0;
  final stopwatch = Stopwatch();
  final GeolocatorService geoService = GeolocatorService();
  // ignore: prefer_final_fields
  List<LatLng> _polyLinesList = [];
  final StopWatchData _stopWatchData = StopWatchData();
  Timer? _clockTimer;
  late String rideTime;
  double rotation = 0;

  @override
  void initState() {
    super.initState();

    _clockTimer = Timer.periodic(
        const Duration(seconds: 1), (timer) => _stopWatchData.startTimer());
    startTime = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatchData.dispose();
    _clockTimer?.cancel();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Position>(
          stream: geoService.getCurrentLocation(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Position position = snapshot.data as Position;
              velocity = position.speed;
              LatLng latLng = LatLng(position.latitude, position.longitude);
              if (!_polyLinesList.contains(latLng)) {
                _polyLinesList.add(latLng);
                if (_polyLinesList.length > 2) {
                  mapController.move(latLng, 18);
                }
                if (_polyLinesList.length == 2) {
                  distance += (geoService.getDistance(
                          lat1: _polyLinesList[0].latitude,
                          lon1: _polyLinesList[0].longitude,
                          lat2: _polyLinesList[1].latitude,
                          lon2: _polyLinesList[1].longitude)) /
                      1000;
                } else if (_polyLinesList.length > 2) {
                  distance += (geoService.getDistance(
                          lat1: _polyLinesList[_polyLinesList.length - 2]
                              .latitude,
                          lon1: _polyLinesList[_polyLinesList.length - 2]
                              .longitude,
                          lat2: _polyLinesList.last.latitude,
                          lon2: _polyLinesList.last.longitude)) /
                      1000;
                }
              }

              return Stack(
                children: [
                  Center(
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        minZoom: 5,
                        maxZoom: 18,
                        zoom: 18,
                        center: latLng,
                        rotation: position.heading,
                      ),
                      nonRotatedChildren: [
                        AttributionWidget.defaultWidget(
                          source: 'OpenStreetMap contributors',
                          onSourceTapped: null,
                        ),
                      ],
                      children: [
                        // VectorTileLayer(
                        //   theme: ProvidedThemes.lightTheme(),
                        //   tileProviders: TileProviders(
                        //     {
                        //       'openmaptiles': OfflineMapService()
                        //           .cachingTileProvider(
                        //               apiKey: AppConstants.mapBoxAccessToken),
                        //     },
                        //   ),
                        // ),
                        TileLayer(
                          urlTemplate: AppConstants.mapURl(),
                          // ignore: prefer_const_literals_to_create_immutables
                          additionalOptions: {
                            "access_token": AppConstants.mapBoxAccessToken,
                          },
                          userAgentPackageName: 'com.example.rider_app',
                        ),

                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _polyLinesList,
                              borderStrokeWidth: 1,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          rotate: true,
                          markers: [
                            Marker(
                              point: latLng,
                              width: 80,
                              height: 80,
                              rotate: true,
                              builder: (context) => Image.asset(
                                "assets/images/navigation.png",
                                height: 10,
                                width: 10,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      // ignore: prefer_const_constructors
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Ride In Progress",
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                          StreamBuilder<Duration>(
                            stream: _stopWatchData.durationStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                final timeData = snapshot.data as Duration;
                                rideTime =
                                    _stopWatchData.getTime(duration: timeData);

                                return RideDataWidget(
                                  time: rideTime,
                                  velocity: velocity.toStringAsFixed(2),
                                  distance: distance.toStringAsFixed(3),
                                );
                              }
                              return const RideDataWidget(
                                time: "00:00:00",
                                velocity: '0',
                                distance: '00:000',
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SlideAction(
                              innerColor: Colors.white,
                              outerColor: Colors.black,
                              borderRadius: 10,
                              text: "Slide to Finish",
                              sliderRotate: false,
                              onSubmit: () {
                                _saveData(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  void _saveData(BuildContext context) {
    List<double> startPoint = [
      _polyLinesList.first.latitude,
      _polyLinesList.first.longitude
    ];
    List<double> finishPoint = [
      _polyLinesList.last.latitude,
      _polyLinesList.last.longitude
    ];

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          final rideModel = Provider.of<RideModel>(context, listen: false);
          rideModel.startTime = startTime;
          rideModel.finishTime = DateTime.now();
          rideModel.avgSpeed = velocity.toStringAsFixed(2);
          rideModel.time = rideTime;
          rideModel.distance = distance.toStringAsFixed(3);
          rideModel.finishPoint = finishPoint;
          rideModel.startpoint = startPoint;
          rideModel.finishPoint = finishPoint;
          // rideModel = RideModel(
          //   startTime: startTime,
          //   finishTime: DateTime.now(),
          //   time: rideTime,
          //   distance: ,
          //   avgSpeed: velocity.toStringAsFixed(2),
          //   startpoint: startPoint,
          //   finishPoint: finishPoint,

          // );
          return CameraScreen(
            isRideStart: true,
            rideModel: rideModel,
          );
        },
      ),
    );
  }
}
