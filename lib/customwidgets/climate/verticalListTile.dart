import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sgs/customwidgets/climate/iconValue.dart';
import 'package:sgs/customwidgets/climate/selectButton.dart';
import 'package:sgs/styles.dart';

class VerticalListTile extends StatelessWidget {
  String title;
  MaterialColor color;
  double temperature;
  double humidity;
  String suntime;

  VerticalListTile(
      {Key key,
      this.humidity,
      this.color,
      this.suntime,
      this.temperature,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ),
          IconValue(
            color: color,
            icon: WeatherIcons.wi_thermometer,
            unit: "°C",
            val: temperature.toString(),
          ),
          IconValue(
            color: color,
            icon: WeatherIcons.wi_humidity,
            unit: "%",
            val: humidity.toString(),
          ),
          IconValue(
            color: color,
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
