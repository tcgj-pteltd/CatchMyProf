import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfDex extends StatefulWidget {
  ProfDex({Key key}) : super(key: key);

  @override
  _ProfDexState createState() => _ProfDexState();
}

class _ProfDexState extends State<ProfDex> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('ProfDex'))
          ],
        ),
      ),
    );
  }
}
