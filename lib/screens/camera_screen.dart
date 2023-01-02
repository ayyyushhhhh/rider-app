import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/Models/rider_model.dart';
import 'package:rider_app/screens/preview_screen.dart';
import 'package:rider_app/services/camera_services.dart';

class CameraScreen extends StatefulWidget {
  final bool isRideStart;
  final RideModel? rideModel;

  /// Default Constructor
  const CameraScreen({Key? key, required this.isRideStart, this.rideModel})
      : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    List<CameraDescription> cameras = CameraService.camerasList();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    if (controller.value.isTakingPicture) {
      return null;
    }
    try {
      XFile picture = await controller.takePicture();

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewPage(
            picture: picture,
            hasRideStart: widget.isRideStart,
            rideModel: widget.rideModel,
          ),
        ),
      );
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
                height: 400,
                width: double.infinity,
                child: CameraPreview(
                  controller,
                  key: UniqueKey(),
                )),
          ),
          InkWell(
            onTap: () {
              takePicture();
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
                "Camera \n Button",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewPage(
                      picture: XFile("fg"),
                      hasRideStart: widget.isRideStart,
                      rideModel: widget.rideModel,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.arrow_forward,
                size: 20,
              )),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
