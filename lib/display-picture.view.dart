import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class DisplayPicture extends StatefulWidget {
  String imagePath;

  DisplayPicture({this.imagePath});

  @override
  _DisplayPictureState createState() => _DisplayPictureState();
}

class _DisplayPictureState extends State<DisplayPicture> {
  final cropKey = GlobalKey<CropState>();
  bool shouldCrop = false;

  editImage() async {
    setState(() {
      shouldCrop = true;
    });
  }

  cropImage() async {
    final croppedFile = await ImageCrop.cropImage(
      file: File(widget.imagePath),
      area: cropKey.currentState.area,
    );

    final bytes = await croppedFile.readAsBytes();
    String imageString = base64.encode(bytes);
    print(imageString);

    setState(() {
      widget.imagePath = croppedFile.path;
      shouldCrop = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar imagem'),
        actions: <Widget>[
          FlatButton(
            onPressed: cropImage,
            child: Icon(
              Icons.save,
            ),
          )
        ],
      ),
      body: shouldCrop ? showCropper() : showImage(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit,
        ),
        onPressed: editImage,
      ),
    );
  }

  Widget showImage() {
    return Image.file(
      File(widget.imagePath),
    );
  }

  Widget showCropper() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(20.0),
      child: Crop(
        key: cropKey,
        image: FileImage(
          File(widget.imagePath),
        ),
        aspectRatio: 4.0 / 3.0,
      ),
    );
  }
}
