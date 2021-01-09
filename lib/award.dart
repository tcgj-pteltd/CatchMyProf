import 'dart:ui';

import 'helpers/sphere.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Award extends StatelessWidget {

  final String url;
  Award({Key key, @required this.url}) : super(key: key);

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
