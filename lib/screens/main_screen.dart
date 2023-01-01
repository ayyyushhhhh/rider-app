import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rider_app/screens/camera_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  _checkPermission() async {
    await Permission.location.request();
    await Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    _checkPermission();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return const CameraScreen(
                      isRideStart: false,
                    );
                  }));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                      child: Text(
                    "Demo \n APK",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Ayush Rawat")
          ],
        ),
      ),
    );
  }
}
