import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sgs/customwidgets/datachart.dart';

import '../styles.dart';

class Advanced extends StatefulWidget {
  final temperatures;
  final humiditys;

  Advanced({
    @required this.temperatures,
    @required this.humiditys,
  });

  @override
  _AdvancedState createState() => _AdvancedState();
}

class _AdvancedState extends State<Advanced> {
  SplayTreeMap<DateTime, double> humiditys;
  SplayTreeMap<DateTime, double> temperatures;
  Timer updateTimer;

  @override
  void initState() {
    temperatures = widget.temperatures;
    humiditys = widget.humiditys;

    // defines a timer
    updateTimer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      final ref = fb.reference();

      //access temperatures
      ref
          .child("temperatures")
          .limitToLast(10)
          .once()
          .then((DataSnapshot data) {
        if (this.mounted)
          setState(() {
            temperatures = sortData(data.value);
          });
      });

      //access humiditys
      ref.child("humiditys").limitToLast(10).once().then((DataSnapshot data) {
        if (this.mounted)
          setState(() {
            humiditys = sortData(data.value);
          });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    //cancels the timer in case the widget is not in the build tree anymore
    updateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: isDark(context)
          ? EdgeInsets.only(bottom: 30)
          : EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                child: DataChart(
                  title: "TEMPERATURES",
                  data: temperatures,
                  gradientColors: temperatureGradient,
                ),
              ),
              Container(
                child: DataChart(
                  title: "HUMIDITIES",
                  data: humiditys,
                  gradientColors: humidityGradient,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
