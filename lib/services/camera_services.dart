import 'package:camera/camera.dart';

class CameraService {
  static List<CameraDescription> _cameras = [];
  static void initCamera() async {
    _cameras = await availableCameras();
  }

  static List<CameraDescription> camerasList() {
    return _cameras;
  }
}
