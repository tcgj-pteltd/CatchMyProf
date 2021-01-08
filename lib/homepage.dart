import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void removeImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            _image == null
                ? Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No image selected.'))
                : Column(
              children: <Widget>[
                Image.file(_image, width: 300, height: 300),
                ElevatedButton(
                  onPressed: removeImage,
                  child: Text("Remove Image"),
                ),
                ElevatedButton(
                  onPressed: removeImage,
                  child: Text("Submit"),
                )
              ],
            ),
            ElevatedButton(
              onPressed: getImageFromGallery,
              child: Text("Pick Image"),
            ),
            ElevatedButton(
              onPressed: getImageFromCamera,
              child: Text("Use Camera"),
            )
          ],
        ),
      ),
    );
  }
}
