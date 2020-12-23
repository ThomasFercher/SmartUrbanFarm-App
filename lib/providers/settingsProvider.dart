import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/styles.dart';

class SettingsProvider extends ChangeNotifier {
  var selectedTheme = 0;

  var takeDailyPicture = false;
  var checkbox = false;

  final ref = fb.reference().child("appSettings");

  List<AppTheme> themes = [
    new AppTheme(
        name: "light",
        cardColor: Colors.white,
        background: Colors.white,
        textColor: Colors.black.withOpacity(0.85),
        secondaryTextColor: Colors.black.withOpacity(0.65),
        headlineColor: Colors.black.withOpacity(0.85),
        secondaryColor: Color(0xFF3f51b5),
        primaryColor: Color(0xFF26C281),
        contrast: Colors.grey[100]),
    new AppTheme(
      name: "cool",
      cardColor: background_t,
      background: Colors.red,
      textColor: Colors.white,
      headlineColor: Colors.white,
      primaryColor: Colors.teal[800],
      secondaryColor: Colors.green[300],
    ),
    new AppTheme(
        name: "dark",
        cardColor: Colors.grey[850],
        background: Colors.grey[900],
        textColor: Colors.white,
        headlineColor: Colors.grey[300],
        primaryColor: Color(0xFF26C281),
        secondaryColor: Color(0xFF3f51b5),
        contrast: Colors.grey[800])
  ];

  setCheckbox(vl) {
    checkbox = vl;
    notifyListeners();
  }

  setTakeDailyPicture(vl) {
    takeDailyPicture = vl;
    ref.child("takeDailyPictures").set(takeDailyPicture);
    notifyListeners();
  }

  setTheme(index) {
    selectedTheme = index;
    ref.child("theme").set(selectedTheme);

    notifyListeners();
  }

  bool getSelected(index) {
    if (selectedTheme == index)
      return true;
    else
      return false;
  }

  AppTheme getTheme() {
    return themes[selectedTheme];
  }

  SettingsProvider() {
    ref.child("theme").once().then((value) => selectedTheme = value.value);
  }
}
