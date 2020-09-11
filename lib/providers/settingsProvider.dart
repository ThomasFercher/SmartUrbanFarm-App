import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sgs/styles.dart';

class SettingsProvider extends ChangeNotifier {
  var i = 0;

  var takeDailyPicture = false;
  var checkbox = false;

  setCheckbox(vl) {
    checkbox = vl;
    notifyListeners();
  }

  setTakeDailyPicture(vl) {
    takeDailyPicture = vl;
    notifyListeners();
  }

  setTheme(index) {
    i = index;
    selectedTheme = i;
    notifyListeners();
  }

  bool getSelected(index) {
    if (i == index)
      return true;
    else
      return false;
  }

  SettingsProvider() {
    //loadImages();
  }
}
