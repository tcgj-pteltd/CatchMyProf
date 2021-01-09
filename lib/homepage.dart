import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';

import 'cropper.dart';
import 'helpers/names.dart';
import 'logic/player.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:catch_my_prof/profdex.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image/image.dart' as Img;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  bool _cropped = false;

  final picker = ImagePicker();
  bool isLoading = false;
  String result = "";

  var sharedPreferences;

  @override
  void initState() {
    super.initState();
    restore();
  }

  restore() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Player.updateCollections();
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Img.Image img = Img.decodeImage(await _image.readAsBytes());
      await Navigator.pushNamed(
        context,
        Cropper.routeName,
        arguments:
            CropArgs(_image, img.width.toDouble(), img.height.toDouble()),
      );
      setState(() {
        _cropped = true;
      });
    } else {
      print('No image selected.');
    }

    setState(() {});
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Img.Image img = Img.decodeImage(await _image.readAsBytes());
      await Navigator.pushNamed(
        context,
        Cropper.routeName,
        arguments:
            CropArgs(_image, img.width.toDouble(), img.height.toDouble()),
      );
      setState(() {
        _cropped = true;
      });
    } else {
      print('No image selected.');
    }

    setState(() {});
  }

  void removeImage() {
    setState(() {
      _image = null;
    });
  }

  Future compressImage(File _image) async {
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(_image.path);
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
    String azureDetectUrl =
        "https://catchmyprof.cognitiveservices.azure.com/face/v1.0/detect";
    Dio dio = Dio();
    dio.options.headers["Ocp-Apim-Subscription-Key"] =
        "5a130a8a987a46b793a3564016e439b0";
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
    String azureSimilarUrl =
        "https://catchmyprof.cognitiveservices.azure.com//face/v1.0/findsimilars";
    Dio dio = Dio();
    dio.options.headers["Ocp-Apim-Subscription-Key"] =
        "5a130a8a987a46b793a3564016e439b0";
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> writeImage(String name, int index) async {
    final path = await _localPath;
    Directory('$path/$name').createSync();
    String newImagePath = '$path/$name/$index.jpg';

    return _image.copySync(newImagePath);
  }

  Future<String> getImageDir(String name) async {
    final path = await _localPath;
    final imagePath = '$path/$name';
    if (Directory(imagePath).existsSync()) {
      return imagePath;
    } else {
      return null;
    }
  }

  Future<void> addProf(String name) async {
    int counter = sharedPreferences.getInt(name) ?? 0;
    String escName = name.replaceAll(RegExp(' +'), '_');
    File out = await writeImage(escName, counter);
    if (out == null) {
      print("Error writing");
    }

    sharedPreferences.setInt(name, counter + 1);
    print(counter);
  }

  void showFailDialog(BuildContext context, String input) {
    Widget okButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return Color(0xFF92140C); // Use the component's default.
          },
        )),
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Sure",
                style: TextStyle(color: Colors.white, fontSize: 20))));

    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFF1E1E24),
      title: new Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: new Row(children: <Widget>[
            Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: Divider(
                      color: Color(0xFF92140C),
                      thickness: 4,
                    ))),
            Text('FAIL',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5)),
            Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Divider(
                      color: Color(0xFF92140C),
                      thickness: 4,
                    )))
          ])),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text(input, style: TextStyle(color: Colors.white, fontSize: 20)),
      ]),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showAlertDialog(BuildContext context, String faceId) {
    // set up the button
    Widget okButton = ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          addProf(faceIdToName(faceId)).then((_) {
            Player.updateCollections();
            removeImage();
          });
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            return Color(0xFF92140C); // Use the component's default.
          },
        )),
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("Sweet!",
                style: TextStyle(color: Colors.white, fontSize: 20))));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFF1E1E24),
      title: new Container(
          margin: const EdgeInsets.only(top: 10.0),
          child: new Row(children: <Widget>[
            Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: Divider(
                      color: Color(0xFF92140C),
                      thickness: 4,
                    ))),
            Text('CAUGHT',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5)),
            Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Divider(
                      color: Color(0xFF92140C),
                      thickness: 4,
                    )))
          ])),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text("Professor " + faceIdToName(faceId) + "!",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 30),
        Image(
            image: AssetImage('assets/' + faceIdToIndex(faceId) + '.png'),
            width: 200,
            height: 200),
        SizedBox(height: 30),
        Text("Head to your ProfDex to check it out.",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ]),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void submit() async {
    setState(() {
      isLoading = true;
    });

    _image = await compressImage(_image);

    print("Trying upload");
    String cloudinaryUrl = await uploadImage(_image);

    // https://res.cloudinary.com/jcjc/image/upload/v1610096814/rwvskc2b1pd6z23ssc9d.jpg - has face
    // https://res.cloudinary.com/jcjc/image/upload/v1610096965/zhmke8z8g7xe9nqapwae.jpg - no face
    // https://res.cloudinary.com/jcjc/image/upload/v1610097363/hvrc0abechhdx9f2sb3s.jpg - martin henz

    print("Trying face detection");
    String faceId = await detectFace(cloudinaryUrl);

    if (faceId == "") {
      // No face detected

      showFailDialog(context, "No face detected!");

      setState(() {
        isLoading = false;
      });
      return;
    }

    print("Trying face similarity");
    Response faceSimilarity = await findSimilarFaces(faceId);

    if (faceSimilarity == null) {
      showFailDialog(context, "There is an issue with your connection.");

      setState(() {
        isLoading = false;
      });
      return;
    }

    if (faceSimilarity.data.length == 0 ||
        faceSimilarity.data[0]['confidence'] < 0.4) {
      showFailDialog(context, "This person does not exist in our database.");

      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      result = '';
    });

    showAlertDialog(context, faceSimilarity.data[0]['persistedFaceId']);

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
            child: new Row(children: <Widget>[
              Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      child: Divider(
                        color: Color(0xFF92140C),
                        thickness: 4,
                      ))),
              Text('CATCH MY PROF',
                  style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5)),
              Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Divider(
                        color: Color(0xFF92140C),
                        thickness: 4,
                      )))
            ])),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: _image == null
                ? Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: getImageFromCamera,
                          elevation: 2.0,
                          fillColor: Color(0xFF92140C),
                          child: Text("Snap!",
                              textScaleFactor: 2.0,
                              style: GoogleFonts.poiretOne(
                                  textStyle: TextStyle(color: Colors.white),
                                  fontSize: 30)),
                          padding: EdgeInsets.all(80.0),
                          shape: CircleBorder(),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: TextButton(
                                onPressed: getImageFromGallery,
                                child: new RichText(
                                    text: new TextSpan(
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: 'Or ',
                                        style: new TextStyle(fontSize: 18)),
                                    new TextSpan(
                                        text: 'Gallery',
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18))
                                  ],
                                )))),
                      ],
                    ))
                : isLoading
                    ? Column(children: <Widget>[
                        Text("Who's that professor?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 50),
                        SpinKitSquareCircle(color: Colors.white, size: 100.0)
                      ])
                    : Column(
                        children: <Widget>[
                          (_cropped
                              ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: ClipOval(
                                      child: Image.memory(
                                          _image.readAsBytesSync(),
                                          fit: BoxFit.contain,
                                          width: 300,
                                          height: 300,
                                          gaplessPlayback: true)),
                                )
                              : Image.file(_image, width: 300, height: 300)),
                          SizedBox(height: 50),
                          ElevatedButton(
                              onPressed: submit,
                              style: ButtonStyle(backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Color(
                                      0xFF92140C); // Use the component's default.
                                },
                              )),
                              child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text("Identify",
                                      textScaleFactor: 2.0,
                                      style: GoogleFonts.poiretOne(
                                          textStyle:
                                              TextStyle(color: Colors.white),
                                          fontSize: 22)))),
                          SizedBox(height: 20),
                          TextButton(
                              onPressed: removeImage,
                              child: new RichText(
                                  text: new TextSpan(
                                children: <TextSpan>[
                                  new TextSpan(
                                      text: 'Or ',
                                      style: new TextStyle(fontSize: 18)),
                                  new TextSpan(
                                      text: 'Cancel',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18))
                                ],
                              ))),
                        ],
                      ),
          ),
        ],
      ),
      floatingActionButton: isLoading
          ? null
          : Container(
              height: 90.0,
              width: 90.0,
              child: FloatingActionButton(
                backgroundColor: Color(0xFF92140C),
                onPressed: () {
                  Player.updateCollections();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfDex()));
                },
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.portrait_rounded, size: 36.0),
                      Text("ProfDex", style: TextStyle(fontSize: 9))
                    ]),
              ),
            ),
    );
  }
}
