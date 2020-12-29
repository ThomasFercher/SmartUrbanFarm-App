import 'package:flutter/cupertino.dart';
import 'package:sgs/styles.dart';

class ClimateControl {
  String id;
  String name;
  double temperature;
  double humidity;
  double soilMoisture;
  String suntime;
  double waterConsumption;

  double get getTemperature => temperature;

  set setTemperature(double temperature) => this.temperature = temperature;

  double get getHumidity => humidity;

  set setHumidity(double humidity) => this.humidity = humidity;

  double get getSoilMoisture => soilMoisture;

  set setSoilMoisture(double soilMoisture) => this.soilMoisture = soilMoisture;

  String get getSuntime => suntime;

  set setSuntime(String suntime) => this.suntime = suntime;

  double get getWaterConsumption => waterConsumption;

  set setWaterConsumption(double waterConsumption) =>
      this.waterConsumption = waterConsumption;

  set setName(String name) => this.name = name;

  String get getName => name;

  String get getID => id;

  Map<String, String> getJson() {
    return <String, String>{
      "id": id,
      "name": name,
      "tempSoll": temperature.toString(),
      "humiditySoll": humidity.toString(),
      "soilMoistureSoll": soilMoisture.toString(),
      "suntime": suntime,
      "waterConsumption": waterConsumption.toString(),
    };
  }

  ClimateControl.fromJson(Map<dynamic, dynamic> json) {
    this.id = json["id"];
    this.name = json["name"];
    this.temperature = double.parse(json["tempSoll"]);
    this.humidity = double.parse(json["humiditySoll"]);
    this.soilMoisture = double.parse(json["soilMoistureSoll"]);
    this.suntime = json["suntime"];
    this.waterConsumption = double.parse(json["waterConsumption"]);
  }

  ClimateControl({
    @required this.name,
    @required this.temperature,
    @required this.humidity,
    @required this.soilMoisture,
    @required this.suntime,
    @required this.waterConsumption,
  }) {
    this.id = uuid.v1(); // create random time based id
  }
}
