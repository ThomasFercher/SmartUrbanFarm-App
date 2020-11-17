import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sgs/main.dart';
import 'package:sgs/objects/environmentSettings.dart';

import '../styles.dart';

class DashboardProvider with ChangeNotifier, DiagnosticableTreeMixin {
  double temperature = 0.0;
  double tempSoll = 25;

  double humidity = 0.0;
  double soilMoisture = 0.0;
  double humiditySoll = 50;
  double soilMoistureSoll = 50;
  double waterTankLevel = 40;
  double waterAnimationProgress;
  String suntime = "02:30 - 18:00";
  SplayTreeMap<DateTime, double> temperatures = new SplayTreeMap();
  SplayTreeMap<DateTime, double> humiditys = new SplayTreeMap();
  EnvironmentSettings activeEnvironment;
  List<EnvironmentSettings> environments = [];

  //Reference to the Firebase
  final ref = fb.reference();

  DashboardProvider() {
    Timer.periodic(Duration(seconds: 60), (timer) {
      print("reloaded");
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
    await ref.child("suntime").once().then((DataSnapshot data) {
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

  SplayTreeMap<DateTime, double> sortData(Map<dynamic, dynamic> data) {
    Map<DateTime, double> d = data.map((key, value) => MapEntry(
        DateTime.parse(key),
        value.runtimeType == double ? value : double.parse(value)));
    SplayTreeMap<DateTime, double> sorted =
        new SplayTreeMap<DateTime, double>.from(d, (a, b) => a.compareTo(b));
    return sorted;
  }

  Future<void> loadData() async {
    temperature = await loadTemperature();
    humidity = await loadHumidity();
    soilMoisture = await loadSoilMoisture();
    suntime = await loadSuntime();
    temperatures = await loadTemperatures();
    humiditys = await loadHumiditys();
    environments = await loadEnvironments();
    activeEnvironment = await loadActiveEnvironment();

    notifyListeners();
  }

  Future<List<EnvironmentSettings>> loadEnvironments() async {
    List<EnvironmentSettings> env = [];
    await ref.child("environments").once().then((DataSnapshot data) {
      Map<dynamic, dynamic> list = data.value;
      list.forEach((key, value) {
        env.add(new EnvironmentSettings.fromJson(value, key));
      });
    });
    return env;
  }

  Future<EnvironmentSettings> loadActiveEnvironment() async {
    EnvironmentSettings env;
    await ref.child("activeEnvironment").once().then((DataSnapshot data) {
      Map<dynamic, dynamic> list = data.value;
      EnvironmentSettings activeNoName =
          new EnvironmentSettings.fromJson(list, "NoName");

      env = environments.firstWhere((e) =>
          e.temperature == activeNoName.temperature &&
          e.humidity == activeNoName.humidity &&
          e.soilMoisture == activeNoName.soilMoisture &&
          e.suntime == activeNoName.suntime &&
          e.waterConsumption == activeNoName.waterConsumption);
    });
    return env;
  }

  void editEnvironment(EnvironmentSettings initial, EnvironmentSettings e_s) {
    if (initial == activeEnvironment) {
      setActiveEnvironment(e_s);
    }
    environments[environments.indexOf(initial)] = e_s;
    fb.reference().child('environments').child(e_s.name).set(e_s.getJson());
    notifyListeners();
  }

  void createEnvironment(EnvironmentSettings e_s) {
    environments.add(e_s);
    fb.reference().child('environments').child(e_s.name).set(e_s.getJson());
    notifyListeners();
  }

  void setActiveEnvironment(EnvironmentSettings e_s) {
    activeEnvironment = e_s;

    fb.reference().child('activeEnvironment').set(e_s.getJson());
    notifyListeners();
  }

  void deleteEnvironment(EnvironmentSettings e_s) {
    environments.remove(e_s);
    fb.reference().child('environments').child(e_s.name).remove();
    notifyListeners();
  }
}
