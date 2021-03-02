import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sgs/objects/climateControl.dart';
import 'package:sgs/styles.dart';

class ClimateControlProvider extends ChangeNotifier {
  ClimateControl climateSettings;

  String sel_phase = GROWPHASEVEGETATION;

  ClimateControlProvider(settings) : this.climateSettings = settings;

  ClimateControl getSettings() {
    return climateSettings;
  }

  changePhase(new_sel_phase) {
    sel_phase = new_sel_phase;
    notifyListeners();
  }

  changeTemperature(v, phase) {
    climateSettings.setTemperature(v, phase);
    notifyListeners();
  }

  changeHumidity(v, phase) {
    climateSettings.setHumidity(v, phase);
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

  changeSuntime(v, phase) {
    climateSettings.setSuntime(v, phase);
    notifyListeners();
  }

  changeAutomaticWatering(v) {
    climateSettings.automaticWatering = v;
    notifyListeners();
  }
}
