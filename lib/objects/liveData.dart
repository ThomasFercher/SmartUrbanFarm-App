import 'package:flutter/cupertino.dart';

class LiveData {
  double temperature;
  double humidity;
  double soilMoisture;
  double waterTankLevel;
  double growProgress;

  Map<String, String> getJson() {
    return <String, String>{
      "tempSoll": temperature.toString(),
      "humiditySoll": humidity.toString(),
      "soilMoistureSoll": soilMoisture.toString(),
      "growProgress": growProgress.toString(),
      "waterTankLevel": waterTankLevel.toString(),
    };
  }

  LiveData.fromJson(Map<dynamic, dynamic> json) {
    this.temperature = double.parse(json["temperature"]);
    this.humidity = double.parse(json["humidity"]);
    this.soilMoisture = double.parse(json["soilMoisture"]);
    this.growProgress = double.parse(json["growProgress"]);
    this.waterTankLevel = double.parse(json["waterTankLevel"]);
  }

  LiveData({
    @required this.temperature,
    @required this.humidity,
    @required this.soilMoisture,
    @required this.growProgress,
    @required this.waterTankLevel,
  });
}
