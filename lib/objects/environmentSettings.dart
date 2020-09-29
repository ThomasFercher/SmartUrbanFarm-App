import 'package:flutter/cupertino.dart';

class EnvironmentSettings {
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

  set setWaterConsumption(double waterConsumption) => this.waterConsumption = waterConsumption;

  EnvironmentSettings({
    @required this.name,
    @required this.temperature,
    @required this.humidity,
    @required this.soilMoisture,
    @required this.suntime,
    @required this.waterConsumption,
  });
}
