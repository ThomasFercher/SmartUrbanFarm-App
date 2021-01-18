import 'package:flutter/cupertino.dart';
import 'package:sgs/objects/growPhase.dart';
import 'package:sgs/styles.dart';

class ClimateControl {
  static const GROWPHASEVEGETATION = "vegation";
  static const GROWPHASEFLOWER = "flower";
  static const GROWPHASELATEFLOWER = "vegation";

  String id;
  String name;

  double soilMoisture;

  double waterConsumption;
  bool automaticWatering;
  GrowPhase growPhase;

  double getHumidity(String phase) {
    switch (phase) {
      case GROWPHASEVEGETATION:
        return growPhase.vegation_hum;
        break;
      case GROWPHASEFLOWER:
        return growPhase.flower_hum;
        break;
      case GROWPHASELATEFLOWER:
        return growPhase.lateflower_hum;
        break;
      default:
        return 0;
    }
  }

  void setHumidity(double value, String phase) {
    switch (phase) {
      case GROWPHASEVEGETATION:
        growPhase.vegation_hum = value;
        break;
      case GROWPHASEFLOWER:
        growPhase.flower_hum = value;
        break;
      case GROWPHASELATEFLOWER:
        growPhase.lateflower_hum = value;
        break;
    }
  }

  double getTemperature(String phase) {
    switch (phase) {
      case GROWPHASEVEGETATION:
        return growPhase.vegation_temp;
        break;
      case GROWPHASEFLOWER:
        return growPhase.flower_temp;
        break;
      case GROWPHASELATEFLOWER:
        return growPhase.lateflower_temp;
        break;
      default:
        return 0;
    }
  }

  void setTemperature(double value, String phase) {
    switch (phase) {
      case GROWPHASEVEGETATION:
        growPhase.vegation_temp = value;
        break;
      case GROWPHASEFLOWER:
        growPhase.flower_temp = value;
        break;
      case GROWPHASELATEFLOWER:
        growPhase.lateflower_temp = value;
        break;
    }
  }

  String getSuntime(String phase) {
    switch (phase) {
      case GROWPHASEVEGETATION:
        return growPhase.vegation_suntime;
        break;
      case GROWPHASEFLOWER:
        return growPhase.flower_suntime;
        break;
      case GROWPHASELATEFLOWER:
        return growPhase.lateflower_suntime;
        break;
    }
  }

  void setSuntime(String value, String phase) {
    switch (phase) {
      case GROWPHASEVEGETATION:
        growPhase.vegation_suntime = value;
        break;
      case GROWPHASEFLOWER:
        growPhase.flower_suntime = value;
        break;
      case GROWPHASELATEFLOWER:
        growPhase.lateflower_suntime = value;
        break;
    }
  }

  double get getSoilMoisture => soilMoisture;

  set setSoilMoisture(double soilMoisture) => this.soilMoisture = soilMoisture;

  double get getWaterConsumption => waterConsumption;

  set setWaterConsumption(double waterConsumption) =>
      this.waterConsumption = waterConsumption;

  set setName(String name) => this.name = name;

  set setAutomaticWatering(bool aut) => this.automaticWatering = aut;
  String get getName => name;

  String get getID => id;

  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "soilMoisture": soilMoisture.toString(),
      "waterConsumption": waterConsumption.toString(),
      "automaticWatering": automaticWatering,
      "growPhase": growPhase.getJson(),
    };
  }

  ClimateControl.fromJson(Map<dynamic, dynamic> json) {
    this.id = json["id"];
    this.name = json["name"];
    this.soilMoisture = double.parse(json["soilMoisture"]);
    this.waterConsumption = double.parse(json["waterConsumption"]);
    this.automaticWatering = json["automaticWatering"];
    this.growPhase = GrowPhase.fromJson(json["growPhase"]);
  }

  ClimateControl({
    @required this.name,
    @required this.soilMoisture,
    @required this.waterConsumption,
    @required this.automaticWatering,
    @required this.growPhase,
  }) {
    this.id = uuid.v1(); // create random time based id
  }
}
