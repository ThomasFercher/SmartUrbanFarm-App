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
  double humidity = 0.0;
  double soilMoisture = 0.0;
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

  Future<SplayTreeMap<DateTime, double>> loadList(String child) async {
    SplayTreeMap<DateTime, double> values;
    await ref.child(child).once().then((DataSnapshot data) {
      values = sortData(data.value);
    });
    return values;
  }

  Future<T> loadVariable<T>(String variable) async {
    var value;
    await ref.child(variable).once().then((DataSnapshot data) {
      value = T == double ? double.parse(data.value) : data.value;
    });
    return value;
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
    temperature = await loadVariable<double>("temperature");
    humidity = await loadVariable<double>("humidity");
    soilMoisture = await loadVariable<double>("soilMoisture");
    suntime = await loadVariable<String>("suntime");
    temperatures = await loadList("temperatures");
    humiditys = await loadList("humiditys");
    environments = await loadEnvironments();
    activeEnvironment = await loadActiveEnvironment();

    print(temperatures.values.toList().toString());
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

      env = environments.firstWhere(
        (e) =>
            e.temperature == activeNoName.temperature &&
            e.humidity == activeNoName.humidity &&
            e.soilMoisture == activeNoName.soilMoisture &&
            e.suntime == activeNoName.suntime &&
            e.waterConsumption == activeNoName.waterConsumption,
      );
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
