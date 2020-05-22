import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sgs/customwidgets/dayslider.dart';
import 'package:sgs/customwidgets/temperaturechart.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';

class Home extends StatefulWidget {
  final temperature;
  final humidity;
  Home({this.temperature, this.humidity});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var timeRange = [];
  var temp;
  var humidity;
  Timer updateTimer;
  List<dynamic> temperatures;

  @protected
  @mustCallSuper
  void dispose() {
    updateTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    temp = widget.temperature;
    humidity = widget.humidity;
    temperatures = ["1.0"]; //todo gayshit
    super.initState();
    // defines a timer

    updateTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (this.mounted) {
        final ref = fb.reference();
        ref.child("temperature").once().then((DataSnapshot data) {
          setState(() {
            temp = data.value;
          });
        });
        ref.child("temperatures").limitToLast(10).once().then((DataSnapshot data) {
          Map<dynamic, dynamic> temps = data.value;
          setState(() {
            temperatures = temps.values.toList();
          });
        });
        ref.child("humidity").orderByKey().once().then((DataSnapshot data) {
          setState(() {
            humidity = data.value;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            GridView.count(
              padding: EdgeInsets.only(top: 0, left: 10, right: 10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              shrinkWrap: true,
              children: <Widget>[
                CardData(
                  icon: WeatherIcons.thermometer,
                  label: "Temperatur",
                  text: "$temp°C",
                ),
                CardData(
                  icon: WeatherIcons.humidity,
                  label: "Luftfeuchtigkeit",
                  text: "$humidity%",
                ),
                CardData(
                  icon: WeatherIcons.barometer,
                  label: "Bodenfeuchtigkeit",
                  text: "43.80%",
                ),
                /*   CardData(
                  icon: LineIcons.sun_o,
                  label: "DayTime",
                  text: "Day",
                ),
                CardData(
                  icon: LineIcons.sun_o,
                  label: "Luftfeuchtigkeit",
                  text: "85%",
                ),
                CardData(
                  icon: LineIcons.sun_o,
                  label: "Luftfeuchtigkeit",
                  text: "85%",
                ),*/
              ],
            ),
            Container(
              child: DaySlider(
                f: (t) => setState(
                  () => timeRange = t,
                ),
              ),
            ),
            Container(
              child: Column(children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: new Text(
                    "Temperatures",
                    style: TextStyle(
                        color: isDark(context) ? accentColor : accentColor_d,
                        fontSize: 30),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 30,
                  child: TemperatureChart(
                    temperatures: temperatures,
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class CardData extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;

  CardData({
    @required this.icon,
    @required this.text,
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: getCardElavation(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: isDark(context) ? accentColor_d : Colors.white,
        child: Container(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Icon(
                    icon,
                    size: 20,
                  ),
                ),
                Container(
                  child: new Text(
                    label,
                    style: Theme.of(context).textTheme.display3,
                  ),
                ),
                Container(
                  child: new Text(
                    text,
                    style: Theme.of(context).textTheme.display4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
