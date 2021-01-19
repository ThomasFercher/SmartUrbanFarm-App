import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/climate/dayslider.dart';
import 'package:sgs/customwidgets/climate/editVariable.dart';
import 'package:sgs/objects/growPhase.dart';
import 'package:sgs/objects/vpd.dart';
import 'package:sgs/providers/climateControlProvider.dart';

class GrowthItem extends StatelessWidget {
  final String phase;

  const GrowthItem({Key key, this.phase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ClimateControlProvider>(builder: (context, pr, child) {
      Tween temp =
          VPD.getMinMaxLowFromHum(pr.climateSettings.getHumidity(phase), phase);
      double minTemp = temp.begin;
      double maxTemp = temp.end;
      Tween hum = VPD.getMinMaxLowFromTemp(
          pr.climateSettings.getTemperature(phase), phase);
      double minHum = hum.begin;
      double maxHum = hum.end;

      String suntime = pr.climateSettings.getSuntime(phase);
      return Container(
        child: Column(
          children: [
            EditVariable(
              value: pr.climateSettings.getTemperature(phase),
              color: Colors.redAccent,
              title: "Temperature",
              unit: "°C",
              icon: WeatherIcons.wi_thermometer,
              minVal: minTemp,
              maxVal: maxTemp,
              min: 10,
              max: 45,
              onValueChanged: (v) {
                if (v > maxHum) {
                  pr.changeHumidity(
                      VPD.getMinMaxLowFromTemp(v, phase).begin, phase);
                } else if (v < minHum) {
                  pr.changeHumidity(
                      VPD.getMinMaxLowFromTemp(v, phase).end, phase);
                }
                pr.changeTemperature(v, phase);
              },
              isChild: true,
            ),
            EditVariable(
              value: pr.climateSettings.getHumidity(phase),
              title: "Humidty",
              unit: "%",
              icon: WeatherIcons.wi_humidity,
              minVal: minHum,
              maxVal: maxHum,
              min: 30,
              max: 90,
              onValueChanged: (v) {
                if (v > maxHum) {
                  pr.changeTemperature(
                      VPD.getMinMaxLowFromHum(v, phase).begin, phase);
                } else if (v < minHum) {
                  pr.changeTemperature(
                      VPD.getMinMaxLowFromHum(v, phase).end, phase);
                }
                pr.changeHumidity(v, phase);
              },
              isChild: true,
            ),
            DaySlider(
              onValueChanged: (v) => pr.changeSuntime(v, phase),
              initialTimeString: suntime,
              key: new Key(phase),
            ),
          ],
        ),
      );
    });
  }
}
