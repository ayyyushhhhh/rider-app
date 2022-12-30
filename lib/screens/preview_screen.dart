import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/Models/rider_model.dart';

import 'package:rider_app/screens/map_screen.dart';
import 'package:rider_app/screens/ride_info_screen.dart';

class PreviewPage extends StatelessWidget {
  final bool isRideStart;
  final RideModel? rideModel;

  const PreviewPage(
      {Key? key,
      required this.picture,
      required this.isRideStart,
      this.rideModel})
      : super(key: key);

  final XFile picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const Text("Picture Preview"),
            // const SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   height: 400,
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(5),
            //   child: Image.file(File(picture.path), fit: BoxFit.cover),
            // ),
            const Text("Picture Preview"),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 400,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              child: const Placeholder(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: const Center(
                          child: Text(
                            "Retake",
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (isRideStart == false)
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const MapScreen();
                          }));
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: const Center(
                            child: Text(
                              "Start Ride >",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (isRideStart == true)
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return RideInfoScreen(
                              rideModel: rideModel!,
                            );
                          }));
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: const Center(
                            child: Text(
                              "Finish Ride",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
