import 'package:catch_my_prof/award.dart';

import 'helpers/names.dart';
import 'logic/player.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfDex extends StatefulWidget {
  ProfDex({Key key}) : super(key: key);

  @override
  _ProfDexState createState() => _ProfDexState();
}

class _ProfDexState extends State<ProfDex> {
  List<String> profNames = PROF_NAMES;
  List<int> profCollections = Player.getCollections();

  String getProfDexStatus() {
    int total = profNames.length;
    int collected = 0;
    for (int i = 0; i < total; i++) {
      if (profCollections[i] > 0) {
        collected++;
      }
    }

    return collected.toString() +
        " out of " +
        total.toString() +
        " profs collected! (" +
        (collected / total * 100).toStringAsPrecision(3) +
        "%)";
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
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 5),
            Text(getProfDexStatus(),
                style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 10),
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
                      child: Column(children: <Widget>[
                        profCollections[index] == 0
                            ? Image(
                                image: NetworkImage(
                                    "https://mpng.subpng.com/20180319/yge/kisspng-computer-icons-person-symbol-meridian-energy-group-person-icon-145444-bryan-le-photography-5ab04a4e37af55.3382397515215027982281.jpg"),
                                width: 100,
                                height: 100)
                            : GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Award(url:   'assets/' + index.toString() + '.png'))
                    );
                    },
                  child: Image(
                                image: AssetImage(
                                    'assets/' + index.toString() + '.png'),
                                width: 100,
                                height: 100)),
                        SizedBox(height: 10),
                        Text(profNames[index] +
                            ": " +
                            profCollections[index].toString())
                      ]),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          color: Colors.white));
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
