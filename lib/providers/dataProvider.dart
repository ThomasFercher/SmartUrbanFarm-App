import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sgs/main.dart';
import 'package:sgs/objects/climateControl.dart';
import 'package:sgs/objects/liveData.dart';

import '../styles.dart';

class DataProvider with ChangeNotifier, DiagnosticableTreeMixin {
  //Live Data
  LiveData liveData = new LiveData(
    temperature: 0.0,
    humidity: 0.0,
    soilMoisture: 0.0,
    growProgress: 0.0,
    waterTankLevel: 0.0,
  );

  //Lists
  SplayTreeMap<DateTime, double> temperatures = new SplayTreeMap();
  SplayTreeMap<DateTime, double> humudities = new SplayTreeMap();
  SplayTreeMap<DateTime, double> moistures = new SplayTreeMap();

  //Climates
  ClimateControl activeClimate;
  List<ClimateControl> climates = [];

  //Reference to the Firebase
 
  final ref = firebaseDatabase.reference();
  

  DataProvider() {
  
  }

  SplayTreeMap<DateTime, double> getTemperatures() {
    return temperatures;
  }

  SplayTreeMap<DateTime, double> getHumiditys() {
    return humudities;
  }

  Future<SplayTreeMap<DateTime, double>> loadMap(String child) async {
    SplayTreeMap<DateTime, double> map;
    await ref.child(child).once().then((DataSnapshot data) {
      map = sortData(data.value);
    });
    return map;
  }

  Future<LiveData> getLiveData() async {
    LiveData initialLiveData;
    // Load the inital value
    await ref.child("liveClimate").once().then((DataSnapshot data) {
      initialLiveData = new LiveData.fromJson(data.value);
    });

    // On value changes update the liveData Object
    ref.child("liveClimate").onValue.listen((event) {
      var liveClimateJson = event.snapshot.value;
      liveData = LiveData.fromJson(liveClimateJson);
      notifyListeners();
    });

    return initialLiveData;
  }

  SplayTreeMap<DateTime, double> sortData(Map<dynamic, dynamic> data) {
    // Parse Map<dynamic, dynamic> to Map<DateTime, double>
    Map<DateTime, double> parsedData = data.map(
      (key, value) => MapEntry(
        DateTime.parse(key),
        value.runtimeType == double ? value : double.parse(value),
      ),
    );
    // Sort Map using the DateTime Comparator
    SplayTreeMap<DateTime, double> sorted =
        new SplayTreeMap<DateTime, double>.from(
      parsedData,
      (a, b) => a.compareTo(b),
    );
    return sorted;
  }

  Future<void> loadData() async {
    // Load all Climates
    climates = await loadClimates();
    activeClimate = await loadActiveClimate();

    // Load Live Data
    liveData = await getLiveData();

    // Load all Lists
    temperatures = await loadMap("temperatures");
    humudities = await loadMap("humiditys");

    notifyListeners();
  }

  Future<List<ClimateControl>> loadClimates() async {
    List<ClimateControl> envList = [];
    await ref.child("climates").once().then((DataSnapshot data) {
      Map<dynamic, dynamic> list = data.value;
      if (list == null || list.isEmpty) {
        return [];
      }

      list.forEach((key, value) {
        envList.add(new ClimateControl.fromJson(value));
      });
    });
    return envList;
  }

  Future<ClimateControl> loadActiveClimate() async {
    ClimateControl env;
    await ref.child("activeClimate").once().then((DataSnapshot data) {
      Map<dynamic, dynamic> activeClimateJson = data.value;
      env = new ClimateControl.fromJson(activeClimateJson);
    });
    return env;
  }

  void editClimate(ClimateControl initial, ClimateControl newClimate) {
    // If the active Climate is edited update active climate aswell
    if (initial.getID == activeClimate.getID) {
      setActiveClimate(newClimate);
    }
    // get the local ClimateControl Object by matching the id
    ClimateControl clim =
        climates.singleWhere((clim) => initial.getID == clim.getID);
    // edit in local list
    climates[climates.indexOf(clim)] = newClimate;
    // edit in firebase
    firebaseDatabase
        .reference()
        .child('climates')
        .child(initial.getID)
        .update(newClimate.getJson());

    notifyListeners();
  }

  void createClimate(ClimateControl newClimate) {
    // add Climate to local List
    climates.add(newClimate);
    // add Climate to Firebase
    firebaseDatabase
        .reference()
        .child('climates')
        .child(newClimate.getID)
        .set(newClimate.getJson());
    notifyListeners();
  }

  void setActiveClimate(ClimateControl climate) {
    activeClimate = climate;
    firebaseDatabase.reference().child('activeClimate').set(climate.getJson());
    notifyListeners();
  }

  void deleteClimate(ClimateControl climate) {
    // Remove Climate locally
    climates.remove(climate);
    // Remove Climate in firebase
    firebaseDatabase
        .reference()
        .child('climates')
        .child(climate.getID)
        .remove();
    notifyListeners();
  }
}
