import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Models/rider_model.dart';

import 'package:rider_app/screens/map_screen.dart';
import 'package:rider_app/screens/ride_info_screen.dart';
import 'package:rider_app/services/firebase/cloud_storage.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class PreviewPage extends StatelessWidget {
  final bool hasRideStart;
  final RideModel? rideModel;

  const PreviewPage(
      {Key? key,
      required this.picture,
      required this.hasRideStart,
      this.rideModel})
      : super(key: key);

  final XFile picture;

  Future<void> _uploadImage(RideModel rideModel) async {
    if (hasRideStart == false) {
      final rideId = (Random.secure().nextInt(90000) + 10000).toString();
      rideModel.rideID = rideId;
      rideModel.imagePaths = [];
      rideModel.imagePaths!.add(CloudStorage()
          .uploadFile(
              filePath: "/images/$rideId",
              imageBytes: await picture.readAsBytes())
          .toString());
    } else if (hasRideStart == true) {
      rideModel.imagePaths!.add(CloudStorage()
          .uploadFile(
              filePath: "/images/${rideModel.rideID}",
              imageBytes: await picture.readAsBytes())
          .toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final rideModel = Provider.of<RideModel>(context, listen: false);

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
                  if (hasRideStart == false)
                    Flexible(
                      child: InkWell(
                        onTap: () async {
                          SimpleFontelicoProgressDialog dialog =
                              SimpleFontelicoProgressDialog(
                                  context: context, barrierDimisable: false);
                          dialog.show(message: 'Loging In...');
                          await _uploadImage(rideModel);
                          dialog.hide();

                          // ignore: use_build_context_synchronously
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
                  if (hasRideStart == true)
                    Flexible(
                      child: InkWell(
                        onTap: () {
                          _uploadImage(rideModel);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return RideInfoScreen(
                              rideModel: rideModel,
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
