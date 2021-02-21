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
    this.temperature = json["temperature"] * 1.0;
    this.humidity = json["humidity"] * 1.0;
    this.soilMoisture = json["soilMoisture"] * 1.0;
    this.growProgress = json["growProgress"] * 1.0;
    this.waterTankLevel = json["waterTankLevel"] * 1.0;
  }

  LiveData({
    @required this.temperature,
    @required this.humidity,
    @required this.soilMoisture,
    @required this.growProgress,
    @required this.waterTankLevel,
  });
}
