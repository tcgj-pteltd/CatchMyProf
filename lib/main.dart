import 'package:flutter/material.dart';

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
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Color(0xFF1E1E24),
        scaffoldBackgroundColor: Color(0xFF1E1E24),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

