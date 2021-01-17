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
  bool automatic_watering;

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

  set setAutomaticWatering(bool aut)=> this.automatic_watering = aut;
  String get getName => name;

  String get getID => id;

  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "tempSoll": temperature.toString(),
      "humiditySoll": humidity.toString(),
      "soilMoistureSoll": soilMoisture.toString(),
      "suntime": suntime,
      "waterConsumption": waterConsumption.toString(),
      "automaticWatering": automatic_watering,
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
    this.automatic_watering =json["automaticWatering"];
  }

  ClimateControl(
      {@required this.name,
      @required this.temperature,
      @required this.humidity,
      @required this.soilMoisture,
      @required this.suntime,
      @required this.waterConsumption,
      @required this.automatic_watering}) {
    this.id = uuid.v1(); // create random time based id
  }
}
