import 'dart:convert';
import 'dart:math';

import 'package:flutter/widgets.dart';

import '../styles.dart';
import 'vpdElement.dart';

class VPD {
  static List<VPDElement> vegetationVPD = []; // Early Vegetation
  static List<VPDElement> earlyFlowerVPD = []; // Early Flower
  static List<VPDElement> lateFlowerVPD = []; // Late Flower

  static Tween getMinMaxLowFromTemp(double value, String phase) {
    List<VPDElement> phaseVPD;
    switch (phase) {
      case GROWPHASEVEGETATION:
        phaseVPD = vegetationVPD;
        break;
      case GROWPHASEFLOWER:
        phaseVPD = earlyFlowerVPD;
        break;
      case GROWPHASELATEFLOWER:
        phaseVPD = lateFlowerVPD;
        break;
      default:
        phaseVPD = [];
    }

    int temp = value.round();
    VPDElement vpdElement =
        phaseVPD.firstWhere((vpdElement) => vpdElement.temp == temp);

    return Tween(
      begin: vpdElement.minHum,
      end: vpdElement.maxHum,
    );
  }

  static Tween getMinMaxLowFromHum(double hum, String phase) {
    List<VPDElement> phaseVPD;
    switch (phase) {
      case GROWPHASEVEGETATION:
        phaseVPD = vegetationVPD;
        break;
      case GROWPHASEFLOWER:
        phaseVPD = vegetationVPD;
        break;
      case GROWPHASELATEFLOWER:
        phaseVPD = vegetationVPD;
        break;
      default:
        phaseVPD = [];
    }

    List<VPDElement> vpdElements = phaseVPD
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

    List<dynamic> vegetation = jsonData["vegetation"];
    List<dynamic> earyflower = jsonData["earlyFlower"];
    List<dynamic> lateflower = jsonData["lateFlower"];

    vegetation.forEach(
      (vpdMap) => vegetationVPD.add(
        VPDElement.fromJson(vpdMap),
      ),
    );
    earyflower.forEach(
      (vpdMap) => earlyFlowerVPD.add(
        VPDElement.fromJson(vpdMap),
      ),
    );
    lateflower.forEach(
      (vpdMap) => lateFlowerVPD.add(
        VPDElement.fromJson(vpdMap),
      ),
    );
  }
}
