import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide Theme;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rider_app/Models/rider_model.dart';
// import 'package:vector_map_tiles/vector_map_tiles.dart';
// ignore: depend_on_referenced_packages
// import 'package:vector_tile_renderer/vector_tile_renderer.dart';

import 'package:rider_app/screens/camera_screen.dart';
import 'package:rider_app/screens/ride_info_screen.dart';
import 'package:rider_app/services/geolocator_services.dart';
import 'package:rider_app/services/offline_maps_service.dart';
import 'package:rider_app/services/stop_watch_data.dart';
import 'package:rider_app/widgets/ride_data_widget.dart';
import 'package:rider_app/widgets/slide_action.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

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

  // double _onAccelerate(UserAccelerometerEvent event) {
  //   double newVelocity =
  //       sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

  //   if ((newVelocity - velocity).abs() < 1) {
  //     return 0.0;
  //   }

  //   velocity = newVelocity;
  //   return velocity;
  // }

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
                  mapController.move(latLng, 14);
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
                          urlTemplate:
                              'https://api.mapbox.com/styles/v1/ayyyushhhhh/clc94ph3j005r14n6qft3xz7u/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}',
                          // ignore: prefer_const_literals_to_create_immutables
                          additionalOptions: {
                            "access_token": AppConstants.mapBoxAccessToken,
                          },
                          userAgentPackageName: 'com.example.rider_app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: latLng,
                              width: 80,
                              height: 80,
                              builder: (context) => const FlutterLogo(),
                            ),
                          ],
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _polyLinesList,
                              borderStrokeWidth: 20,
                            ),
                          ],
                        )
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
                                distance +=
                                    velocity * (timeData.inSeconds / 3600);

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
                                      RideModel rideModel = RideModel(
                                        startTime: startTime,
                                        finishTime: DateTime.now(),
                                        time: rideTime,
                                        distance: distance.toStringAsFixed(3),
                                        avgSpeed: velocity.toStringAsFixed(2),
                                        startpoint: startPoint,
                                        finishPoint: finishPoint,
                                        rideID: Random.secure().toString(),
                                      );
                                      return RideInfoScreen(
                                        rideModel: rideModel,
                                      );
                                    },
                                  ),
                                );
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
}
