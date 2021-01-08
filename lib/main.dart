import 'package:catch_my_prof/tabspage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String _title = 'Catch My Prof!';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: TabsPage(),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

