import 'package:catch_my_prof/profdex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: HomePage(),
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        TabNavigationItem(
          page: HomePage(),
          icon: Icon(Icons.shopping_basket),
          title: Text("Shop"),
        ),
        TabNavigationItem(
          page: ProfDex(),
          icon: Icon(Icons.search),
          title: Text("ProfDex"),
        ),
      ];
}
