import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sgs/customwidgets/datachart.dart';

import '../styles.dart';

class Advanced extends StatefulWidget {
  final temperatures;
  final humidites;

  Advanced({@required this.temperatures, @required this.humidites});

  @override
  _AdvancedState createState() => _AdvancedState();
}

class _AdvancedState extends State<Advanced> {
  List<double> temperatures;
  List<double> humiditys;
  Timer updateTimer;
  @override
  void initState() {
    temperatures = widget.temperatures;
    humiditys = widget.humidites;
    // defines a timer
    updateTimer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      if (this.mounted) {
        final ref = fb.reference();
        ref
            .child("temperatures")
            .limitToLast(10)
            .once()
            .then((DataSnapshot data) {
          Map<dynamic, dynamic> temps = data.value;
          setState(() {
            temperatures = temps.values.toList().cast<double>();
          });
        });

        ref.child("humiditys").limitToLast(10).once().then((DataSnapshot data) {
          Map<dynamic, dynamic> temps = data.value;
          setState(() {
            humiditys = temps.values.toList().cast<double>();
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              child: DataChart(
                title: "Temperatures",
                data: temperatures,
                gradientColors: temperatureGradient,
              ),
            ),
            Container(
              child: DataChart(
                title: "Humidities",
                data: humiditys,
                gradientColors: humidityGradient,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
