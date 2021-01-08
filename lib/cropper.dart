import 'dart:io';
import 'dart:ui' as ui;

import 'package:crop/crop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:shared_preferences/shared_preferences.dart';

class CropArgs {
  final File image;
  final double width;
  final double height;

  CropArgs(this.image, this.width, this.height);
}

class Cropper extends StatefulWidget {
  static const routeName = '/cropper';

  Cropper({Key key}) : super(key: key);

  @override
  _CropperState createState() => _CropperState();
}

class _CropperState extends State<Cropper> {
  final _controller = CropController(aspectRatio: 1);
  double _rotation = 0;
  BoxShape _shape = BoxShape.rectangle;
  File _image;

  Future onCrop() async {
    SimpleDialog alert = SimpleDialog(
      title: Text("Are you satisfied?"),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            SimpleDialogOption(
              child: Text("Confirm"),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        ),
      ],
    );

    bool shouldContinue = await showDialog(
      context: context,
      builder: (context) => alert,
    );

    if (!shouldContinue) {
      return;
    }

    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cropped = await _controller.crop(pixelRatio: pixelRatio);
    var pngBytes = await cropped.toByteData(format: ui.ImageByteFormat.png);
    var jpgBytes = Img.encodeJpg(Img.decodePng(pngBytes.buffer.asUint8List()));
    _image.writeAsBytesSync(jpgBytes, flush: true);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final CropArgs args = ModalRoute.of(context).settings.arguments;
    _image = args.image;
    double aspect = args.width / args.height;
    if (aspect > 1) {
      aspect = 1.0 / aspect;
    }

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
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 48.0)
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF92140C), width: 5),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Crop(
                  controller: _controller,
                  shape: _shape,
                  child: Image.file(args.image,
                      fit: BoxFit.cover,
                  ),
                  helper: DottedBorder(
                    padding: EdgeInsets.zero,
                    strokeWidth: 2,
                    strokeCap: StrokeCap.round,
                    color: Colors.white,
                    dashPattern: [10, 8],
                    borderType: BorderType.Oval,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width:2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.undo,
                    color: Colors.white,
                  ),
                  tooltip: 'Undo',
                  onPressed: () {
                    _controller.rotation = 0;
                    _controller.scale = 1;
                    _controller.offset = Offset.zero;
                    setState(() {
                      _rotation = 0;
                    });
                  },
                ),
                Expanded(
                  child: SliderTheme(
                    data: Theme.of(context).sliderTheme,
                    child: Slider(
                      divisions: 360,
                      value: _rotation,
                      min: -180,
                      max: 180,
                      label: '$_rotation°',
                      onChanged: (n) {
                        setState(() {
                          _rotation = n.roundToDouble();
                          _controller.rotation = _rotation;
                        });
                      },
                    ),
                  ),
                ),
                PopupMenuButton<double>(
                  icon: Icon(
                    Icons.aspect_ratio,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("Original"),
                      value: aspect,
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      child: Text("1:1"),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text("16:9"),
                      value: 16.0 / 9.0,
                    ),
                    PopupMenuItem(
                      child: Text("4:3"),
                      value: 4.0 / 3.0,
                    ),
                    PopupMenuItem(
                      child: Text("3:4"),
                      value: 3.0 / 4.0,
                    ),
                    PopupMenuItem(
                      child: Text("9:16"),
                      value: 9.0 / 16.0,
                    ),
                  ],
                  tooltip: 'Aspect Ratio',
                  onSelected: (x) {
                    _controller.aspectRatio = x;
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  tooltip: 'Crop Shape',
                  onPressed: onCrop,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
