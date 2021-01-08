import 'package:flutter/material.dart';

import 'cropper.dart';
import 'homepage.dart';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Catch My Prof!';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primaryColor: Color(0xFF1E1E24),
        scaffoldBackgroundColor: Color(0xFF1E1E24),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/cropper': (context) => Cropper(),
      },
    );
  }
}

