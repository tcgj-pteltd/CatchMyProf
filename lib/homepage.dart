import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:catch_my_prof/profdex.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;

  final picker = ImagePicker();
  bool isLoading = false;
  String result = "";

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

  Future compressImage(File _image) async {
    ImageProperties properties = await FlutterNativeImage.getImageProperties(_image.path);
    return await FlutterNativeImage.compressImage(_image.path,
        quality: 90,
        targetWidth: 500,
        targetHeight: (properties.height * 500 / properties.width).round());
  }

  Future uploadImage(File image) async {
    const url = "https://api.cloudinary.com/v1_1/jcjc/upload";

    Dio dio = Dio();
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image.path,
      ),
      "upload_preset": "byiqopjd",
      "cloud_name": "jcjc",
    });

    var data;
    try {
      Response response = await dio.post(url, data: formData);

      data = jsonDecode(response.toString());
      print(data['secure_url']);
    } catch (e) {
      print(e);
    }

    return data['secure_url'];
  }

  Future detectFace(String url) async {
    String azureDetectUrl = "https://catchmyprof.cognitiveservices.azure.com/face/v1.0/detect";
    Dio dio = Dio();
    dio.options.headers["Ocp-Apim-Subscription-Key"] = "5a130a8a987a46b793a3564016e439b0";
    dio.options.headers["Content-Type"] = "application/json";

    var faceId;
    try {
      Response response = await dio.post(azureDetectUrl, data: {
        "url": url,
      });

      if (response.data.length == 0) {
        faceId = "";
      } else {
        faceId = response.data[0]['faceId'];
      }

      print(faceId);
    } catch (e) {
      print(e);
    }

    return faceId;
  }

  Future findSimilarFaces(String id) async {
    String azureSimilarUrl = "https://catchmyprof.cognitiveservices.azure.com//face/v1.0/findsimilars";
    Dio dio = Dio();
    dio.options.headers["Ocp-Apim-Subscription-Key"] = "5a130a8a987a46b793a3564016e439b0";
    dio.options.headers["Content-Type"] = "application/json";

    Response res;
    try {
      Response response = await dio.post(azureSimilarUrl, data: {
        "faceId": id,
        "faceListId": "sample-list",
        "maxNumOfCandidatesReturned": 1,
        "mode": "matchFace"
      });

      res = response;
      print(response);
    } catch (e) {
      print(e);
    }

    return res;
  }

  void submit() async {
    setState(() {
      isLoading = true;
    });

    File compressedFile = await compressImage(_image);

    print("Trying upload");
    String cloudinaryUrl = await uploadImage(compressedFile);

    // https://res.cloudinary.com/jcjc/image/upload/v1610096814/rwvskc2b1pd6z23ssc9d.jpg - has face
    // https://res.cloudinary.com/jcjc/image/upload/v1610096965/zhmke8z8g7xe9nqapwae.jpg - no face
    // https://res.cloudinary.com/jcjc/image/upload/v1610097363/hvrc0abechhdx9f2sb3s.jpg - martin henz

    print("Trying face detection");
    String faceId = await detectFace(cloudinaryUrl);

    if (faceId == "") {
      // No face detected
      setState(() {
        result = "No face detected";
        isLoading = false;
      });
      return;
    }

    print("Trying face similarity");
    Response faceSimilarity = await findSimilarFaces(faceId);

    if (faceSimilarity.data.length == 0 || faceSimilarity.data[0]['confidence'] < 0.4) {
      setState(() {
        result = "No similar faces found";
        isLoading = false;
      });
      return;
    }

    setState(() {
      result = faceSimilarity.data[0]['persistedFaceId'];
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: new Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: new Row(
                children: <Widget>[
                  Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(right: 20.0),
                          child: Divider(
                            color: Color(0xFF92140C),
                            thickness: 4,
                          )
                      )
                  ),
                  Text('CATCH MY PROF', style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Divider(
                            color: Color(0xFF92140C),
                            thickness: 4,
                          )
                      )
                  )
                ]
            )
        ),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: _image == null
                ? Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: getImageFromCamera,
                          elevation: 2.0,
                          fillColor: Colors.greenAccent,
                          child: Text("Snap!", textScaleFactor: 2.0),
                          padding: EdgeInsets.all(50.0),
                          shape: CircleBorder(),
                        ),
                        TextButton(
                          onPressed: getImageFromGallery,
                          child: new RichText(
                            text: new TextSpan(
                              children: <TextSpan>[
                                new TextSpan(text: 'Or '),
                                new TextSpan(text: 'Gallery', style: new TextStyle(fontWeight: FontWeight.bold))
                              ],
                            )
                          )
                        ),
                      ],
                    ))
                : Column(
                    children: <Widget>[
                      Image.file(_image, width: 300, height: 300),
                      ElevatedButton(
                        onPressed: isLoading ? null : submit,
                        child: Text("Submit"),
                      ),
                      TextButton(
                        onPressed: removeImage,
                        child: Text("Remove Image"),
                      ),
                      Text(result),
                    ],
                  ),
          ),
          Align(

          )
        ],
      ),
    );
  }
}
