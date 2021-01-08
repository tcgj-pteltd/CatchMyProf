import 'package:catch_my_prof/tabnavigationitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

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
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              title: tabItem.title,
            )
        ],
      ),
    );
  }
}