import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:imag/test2.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  runApp(MainApp(cameras: cameras));
}

class MainApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MainApp({required this.cameras}); // Correction ici

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(
        cameras: cameras,
      ),
    );
  }
}
