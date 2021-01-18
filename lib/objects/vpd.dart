import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:sgs/objects/vpdElement.dart';

class VPD {
  static List<VPDElement> lowTranspiration = []; // Early Vegetation
  static List<Map<String, double>> medTranspiration; // Early Flower
  static List<Map<String, double>> highTranspiration; // Late Flower

  static Tween getMinMaxLowFromTemp(double value) {
    int temp = value.round();
    VPDElement vpdElement =
        lowTranspiration.firstWhere((vpdElement) => vpdElement.temp == temp);

    return Tween(
      begin: vpdElement.minHum,
      end: vpdElement.maxHum,
    );
  }

  static Tween getMinMaxLowFromHum(double hum) {
    List<VPDElement> vpdElements = lowTranspiration
        .where((vpdElement) =>
            vpdElement.minHum <= hum && hum <= vpdElement.maxHum)
        .toList();

    double minTemp = 100;
    double maxTemp = -100;
    vpdElements.forEach((vpdElement) {
      minTemp = min(minTemp, vpdElement.temp);
      maxTemp = max(maxTemp, vpdElement.temp);
    });

    return Tween(
      begin: minTemp,
      end: maxTemp,
    );
  }

  Future<void> loadJson(context) async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/json/vpd.json");
    Map<dynamic, dynamic> jsonData = json.decode(data);

    List<dynamic> low = jsonData["lowTranspiration"];
    low.forEach(
      (vpdMap) => lowTranspiration.add(
        VPDElement.fromJson(vpdMap),
      ),
    );

    print(lowTranspiration);
  }
}
