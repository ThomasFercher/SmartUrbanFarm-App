import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/customwidgets/dashboarddraglist.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import '../styles.dart';

class Advanced extends StatelessWidget {
  List<Widget> getItems(DashboardProvider d) {
    return [
      Container(
        key: const Key("temp"),
        child: DataChart(
          title: "TEMPERATURES",
          data: d.getTemperatures(),
          gradientColors: temperatureGradient,
        ),
      ),
      Container(
        key: const Key("humi"),
        child: DataChart(
          title: "HUMIDITIES",
          data: d.getHumiditys(),
          gradientColors: humidityGradient,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            color: getTheme().background[0],
            padding: EdgeInsets.symmetric(vertical: 10),
            child: AppBar(
              title: Text(
                "Advanced Data",
                style: TextStyle(color: getTheme().headlineColor),
              ),
              iconTheme: IconThemeData(color: getTheme().headlineColor),
              backgroundColor: getTheme().background[0],
              elevation: 0,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Consumer<DashboardProvider>(
          builder: (context, d, child) {
            return Container(
              padding: EdgeInsets.only(top: 20),
              child: DashboardDragList(
                items: getItems(d),
              ),
            );
          },
        ),
      ),
    );
  }
}
