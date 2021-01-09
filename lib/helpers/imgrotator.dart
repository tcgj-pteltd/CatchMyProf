import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class ImageRotator extends StatefulWidget {
  String path;
  int count;
  int duration;
  String ext;

  ImageRotator(this.path, this.count, this.duration, this.ext);

  @override
  State<StatefulWidget> createState() => new ImageRotatorState();
}

class ImageRotatorState extends State<ImageRotator> {
  int _pos = 0;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(new Duration(seconds: widget.duration), (timer) {
      setState(() {
        _pos = (_pos + 1) % widget.count;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String path = widget.path + '/' + _pos.toString() + '.' + widget.ext;
    return Image.memory(
      File(path).readAsBytesSync(),
      width: 100,
      height: 100,
      gaplessPlayback: true,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer = null;
    super.dispose();
  }
}