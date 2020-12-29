import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sgs/objects/climateControl.dart';
import 'package:sgs/styles.dart';

class ClimateControlProvider extends ChangeNotifier {
  ClimateControl climateSettings;

  ClimateControlProvider(settings) : this.climateSettings = settings;

  ClimateControl getSettings() {
    return climateSettings;
  }

  changeTemperature(v) {
    climateSettings.setTemperature = v;
    notifyListeners();
  }

  changeHumidity(v) {
    climateSettings.setHumidity = v;
    notifyListeners();
  }

  changeWaterConsumption(v) {
    climateSettings.setWaterConsumption = v;
    notifyListeners();
  }

  changeSoilMoisture(v) {
    climateSettings.setSoilMoisture = v;
    notifyListeners();
  }

  changeName(v) {
    climateSettings.setName = v;
    notifyListeners();
  }

  changeSuntime(v) {
    climateSettings.setSuntime = v;
    notifyListeners();
  }
}
