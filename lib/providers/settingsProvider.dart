import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../objects/appTheme.dart';
import '../objects/settings.dart';
import '../styles.dart';

class SettingsProvider extends ChangeNotifier {
  Settings settings;

  final ref = firebaseDatabase.reference().child("appSettings");

  List<AppTheme> themes = [
    new AppTheme(
      name: "light",
      cardColor: Color(0xFFFDFDFD),
      background: Colors.white,
      textColor: Colors.black.withOpacity(0.85),
      secondaryTextColor: Colors.black.withOpacity(0.65),
      headlineColor: Colors.black.withOpacity(0.85),
      secondaryColor: Color(0xFF3f51b5),
      primaryColor: Color(0xFF26C281),
      contrast: Colors.grey[100],
      disabled: Colors.black12,
    ),
    new AppTheme(
      name: "dark",
      cardColor: Colors.grey[850],
      background: Colors.grey[900],
      textColor: Colors.white,
      headlineColor: Colors.grey[300],
      primaryColor: Color(0xFF26C281),
      secondaryColor: Color(0xFF3f51b5),
      contrast: Colors.grey[850],
      disabled: Colors.white54,
    )
  ];

  Future<void> loadSettings() async {
    await ref.once().then((DataSnapshot snapshot) {
      var settingsJson = snapshot.value;
      settings = Settings.fromJson(settingsJson);
    });
  }

  setNotifications(value) {
    settings.notifications = value;
    ref.child("notifications").set(value);
    notifyListeners();
  }

  setAutomaticTimeLapse(value) {
    settings.automaticTimeLapse = value;
    ref.child("automaticTimeLapse").set(value);
    notifyListeners();
  }

  setTheme(index) {
    settings.theme = index;
    ref.child("theme").set(index);
    notifyListeners();
  }

  bool getSelected(index) {
    if (settings.theme == index)
      return true;
    else
      return false;
  }

  AppTheme getTheme() {
    return themes[settings.theme];
  }
}
