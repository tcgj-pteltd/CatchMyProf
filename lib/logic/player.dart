import '../helpers/names.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Player {
  static List<int> collections = new List(9);

  static List<int> getCollections() {
    return collections;
  }

  static void updateCollections() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    for (int i = 0; i < 9; i++) {
      String profName = PROF_NAMES[i];
      if (sharedPreferences.getInt(profName) == null) {
        sharedPreferences.setInt(profName, 0);
      }

      print(profName);
      print(sharedPreferences.getInt(profName));

      collections[i] = sharedPreferences.getInt(profName) ?? 0;
    }
  }
}