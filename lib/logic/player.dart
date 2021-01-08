import '../helpers/names.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Player {
  static List<int> collections = new List(9);

  static List<int> getCollections() {
    return collections;
  }

  static void updateCollections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < 9; i++) {
      String profName = PROF_NAMES[i];
      if (prefs.containsKey(profName)) {
        collections[i] = prefs.getInt(profName);
      } else {
        collections[i] = 0;
      }
    }
  }
}