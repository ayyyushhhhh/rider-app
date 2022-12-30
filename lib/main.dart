import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/screens/main_screen.dart';
import 'package:rider_app/services/camera_services.dart';
import 'package:rider_app/utils/shared_prefrences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CameraService.initCamera();
  Prefrences.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rider App',
      theme: ThemeData.light(),
      home: const MainScreen(),
    );
  }
}
