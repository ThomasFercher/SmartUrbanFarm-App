import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/styles.dart';

class EnvironmentSettingsProvider extends ChangeNotifier {
  EnvironmentSettings settings;

  EnvironmentSettingsProvider(settings) : this.settings = settings;

  EnvironmentSettings getSettings() {
    return settings;
  }

  changeTemperature(v) {
    settings.setTemperature = v;
    notifyListeners();
  }

  changeHumidity(v) {
    settings.setHumidity = v;
    notifyListeners();
  }

  changeWaterConsumption(v) {
    settings.setWaterConsumption = v;
    notifyListeners();
  }

  changeSoilMoisture(v) {
    settings.setSoilMoisture = v;
    notifyListeners();
  }

  changeName(v) {
    settings.setName = v;
    notifyListeners();
  }

  changeSuntime(v) {
    settings.setSuntime = v;
    notifyListeners();
  }
}
