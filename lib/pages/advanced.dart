import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/general/appBarHeader.dart';
import 'package:sgs/customwidgets/advanced/datachart.dart';
import 'package:sgs/providers/dataProvider.dart';
import '../styles.dart';

class Advanced extends StatelessWidget {
  List<Widget> getItems(DataProvider d) {
    return [
      Padding(padding: EdgeInsets.only(top: borderRadius)),
      Container(
        key: const Key("temp"),
        child: DataChart(
          title: "Temperatures",
          data: d.getTemperatures(),
          gradientColors: temperatureGradient,
          unit: "°C",
        ),
      ),
      Container(
        key: const Key("humi"),
        child: DataChart(
          title: "Humiditys",
          data: d.getHumiditys(),
          gradientColors: humidityGradient,
          unit: "%",
        ),
      ),
      Container(
        key: const Key("soil"),
        child: DataChart(
          title: "Soil Moistures",
          data: d.getHumiditys(),
          gradientColors: [Colors.deepOrange, Colors.deepOrangeAccent],
          unit: "%",
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, d, child) {
        return AppBarHeader(
          title: "Advanced Data",
          isPage: true,
          //     theme: getTheme(),
          body: getItems(d),
          contentPadding: false,
        );
      },
    );
  }
}
