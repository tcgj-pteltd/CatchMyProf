import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'helpers/sphere.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Award extends StatelessWidget {

  final String url;
  Award({Key key, @required this.url}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Sphere(
          surface: url,
          radius: 180,
          latitude: 0,
          longitude: 0,
        ),
      ),
    );
  }
}
