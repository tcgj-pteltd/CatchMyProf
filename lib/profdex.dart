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
                    padding: EdgeInsets.only(top: 48.0),
                    child: Text('ProfDex')),
            new Expanded(
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this would produce 2 rows.
                crossAxisCount: 2,
                // Generate 100 Widgets that display their index in the List
                children: List.generate(10, (index) {
                  return Container(

                      margin: const EdgeInsets.all(15.0),
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      )
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
