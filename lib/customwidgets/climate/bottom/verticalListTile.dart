import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../styles.dart';
import '../edit/selectButton.dart';
import 'iconValue.dart';

class VerticalListTile extends StatelessWidget {
  String title;
  MaterialColor color;
  double temperature;
  double humidity;
  String suntime;
  double width;
  bool isMiddle;
  BorderRadiusGeometry borderRadiusGeo;

  VerticalListTile({
    Key key,
    this.humidity,
    this.color,
    this.suntime,
    this.temperature,
    this.title,
    this.width,
    this.isMiddle,
    this.borderRadiusGeo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(width);
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: color.shade200,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      padding: EdgeInsets.only(bottom: borderRadius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SelectButton(
            color: color,
            title: title,
            icon: MaterialCommunityIcons.sprout,
            enabled: true,
            onPressed: () {},
            borderRadiusGeo: borderRadiusGeo ?? null,
          ),
          IconValue(
            color: color.shade600,
            icon: WeatherIcons.wi_thermometer,
            unit: "°C",
            val: temperature.toString(),
          ),
          IconValue(
            color: color.shade600,
            icon: WeatherIcons.wi_humidity,
            unit: "%",
            val: humidity.toString(),
          ),
          IconValue(
            color: color.shade600,
            icon: WeatherIcons.wi_day_sunny_overcast,
            unit: "",
            val: suntime,
            fontsize: 16,
          ),
        ],
      ),
    );
  }
}
