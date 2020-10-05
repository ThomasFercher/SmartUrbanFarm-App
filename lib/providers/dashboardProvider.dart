import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sgs/main.dart';
import 'package:sgs/objects/environmentSettings.dart';

import '../styles.dart';

class DashboardProvider with ChangeNotifier, DiagnosticableTreeMixin {
  bool alongPressed = false;
  bool get longPressed => alongPressed;
  set longPressed(longPressed) => alongPressed = longPressed;

  bool setting1 = false;
  bool setting2 = false;

  double temperature = 0.0;
  double humidity = 0.0;
  double soilMoisture = 0.0;
  double tempSoll = 25;
  double humiditySoll = 50;
  double soilMoistureSoll = 50;
  double waterTankLevel = 40;
  double waterAnimationProgress;
  bool waterTankMoving = false;

  void setWaterTankMoving(v) {
    waterTankMoving = v;
  }

  String suntime = "02:30 - 18:00";
  SplayTreeMap<DateTime, double> temperatures = new SplayTreeMap();
  SplayTreeMap<DateTime, double> humiditys = new SplayTreeMap();
  final ref = fb.reference();

  List<EnvironmentSettings> settings = [
    new EnvironmentSettings(
      name: "Custom",
      temperature: 50,
      humidity: 50,
      soilMoisture: 50,
      suntime: "02:30 - 18:00",
      waterConsumption: 1,
    ),new EnvironmentSettings(
      name: "Custom",
      temperature: 50,
      humidity: 50,
      soilMoisture: 50,
      suntime: "02:30 - 18:00",
      waterConsumption: 1,
    )
  ];

  DashboardProvider() {
    Timer.periodic(Duration(seconds: 60), (timer) {
      print("aasd");
      loadData();
    });
  }

  SplayTreeMap<DateTime, double> getTemperatures() {
    return temperatures;
  }

  SplayTreeMap<DateTime, double> getHumiditys() {
    return humiditys;
  }

  void suntimeChanged(List<dynamic> suntime) {
    String time = "${suntime[0]} - ${suntime[1]}";
    this.suntime = time;
    fb.reference().child('suntime').set({'suntime': time}).then((_) {});
  }

  void tempSollChanged(double v) {
    v = num.parse(v.toStringAsFixed(1));
    tempSoll = v;
    fb.reference().child('temperatureSoll').set(tempSoll);
    notifyListeners();
  }

  void humiditySollChanged(double v) {
    v = num.parse(v.toStringAsFixed(1));
    humiditySoll = v;
    fb.reference().child('humiditySoll').set(humiditySoll);
    notifyListeners();
  }

  void soilMoistureSollChanged(double v) {
    v = num.parse(v.toStringAsFixed(1));
    soilMoistureSoll = v;
    fb.reference().child('soilMoistureSoll').set(soilMoistureSoll);
    notifyListeners();
  }

  void setWaterAnimationProgress(double v) {
    this.waterAnimationProgress = v;
    notifyListeners();
  }

  Future<SplayTreeMap<DateTime, double>> loadTemperatures() async {
    SplayTreeMap<DateTime, double> temps;
    await ref
        .child("temperatures")
        .limitToLast(10)
        .once()
        .then((DataSnapshot data) {
      temps = sortData(data.value);
    });
    return temps;
  }

  Future<double> loadTemperature() async {
    double temp;
    await ref.child("temperature").once().then((DataSnapshot data) {
      temp = double.parse(data.value);
    });
    return temp;
  }

  Future<double> loadHumidity() async {
    double humidity;
    await ref.child("humidity").once().then((DataSnapshot data) {
      humidity = double.parse(data.value);
    });
    return humidity;
  }

  Future<double> loadSoilMoisture() async {
    double soilMoisture;
    await ref.child("soilMoisture").once().then((DataSnapshot data) {
      soilMoisture = double.parse(data.value);
    });
    return soilMoisture;
  }

  Future<String> loadSuntime() async {
    String suntime;
    await ref
        .child("suntime")
        .child("suntime")
        .once()
        .then((DataSnapshot data) {
      suntime = data.value;
    });
    return suntime;
  }

  Future<SplayTreeMap<DateTime, double>> loadHumiditys() async {
    SplayTreeMap<DateTime, double> humitdites;
    await ref
        .child("humiditys")
        .limitToLast(10)
        .once()
        .then((DataSnapshot data) {
      humitdites = sortData(data.value);
    });
    return humitdites;
  }

  Future<void> loadData() async {
    temperature = await loadTemperature();
    humidity = await loadHumidity();
    soilMoisture = await loadSoilMoisture();
    suntime = await loadSuntime();
    temperatures = await loadTemperatures();
    humiditys = await loadHumiditys();

    notifyListeners();
  }

  void pressed() {
    alongPressed = !alongPressed;
    notifyListeners();
  }
}
