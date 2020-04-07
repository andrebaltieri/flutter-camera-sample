import 'package:camera/camera.dart';
import 'package:flucam/display-picture.view.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TakePicture extends StatefulWidget {
  final CameraDescription camera;

  const TakePicture({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _TakePictureState createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olha o passarinho..."),
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await _controller.takePicture(path);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPicture(
                  imagePath: path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
