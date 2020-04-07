import 'package:camera/camera.dart';
import 'package:flucam/take-picture.view.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePicture(
        camera: firstCamera,
      ),
    ),
  );
}
