import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sgs/customwidgets/carddata.dart';
import 'package:sgs/customwidgets/dayslider.dart';
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
  //states
  var timeRange = [];
  var temp;
  var humidity;
  Timer updateTimer;

  @protected
  @mustCallSuper
  void dispose() {
    //cancels the timer in case the widget is not in the build tree anymore
    updateTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    //sets given initial values
    temp = widget.temperature;
    humidity = widget.humidity;

    // defines a timer
    updateTimer = Timer.periodic(
      Duration(seconds: 60),
      (Timer t) {
        final ref = fb.reference();
        //accesses the child "temperatures" value and calls setState
        ref.child("temperature").once().then((DataSnapshot data) {
          if (this.mounted)
            setState(() {
              temp = data.value;
            });
        });
        //accesses the child "humidity" value and calls setState
        ref.child("humidity").once().then((DataSnapshot data) {
          if (this.mounted)
            setState(() {
              humidity = data.value;
            });
        });
      },
    );

    super.initState();
  }

  //gets called when the slider changes in value and updates the child "suntime" in the firebase database
  void suntimeChanged(List<dynamic> suntime) {
    String time = "${suntime[0]} - ${suntime[1]}";
    fb.reference().child('suntime').set({'suntime': time}).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            sectionTitle(context, "DETAILS",
                isDark(context) ? accentColor : accentColor),
            GridView.count(
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
                  iconColor: Colors.redAccent,
                ),
                CardData(
                  icon: WeatherIcons.humidity,
                  label: "Luftfeuchtigkeit",
                  text: "$humidity%",
                  iconColor: Colors.blueAccent,
                ),
                CardData(
                  icon: WeatherIcons.barometer,
                  label: "Bodenfeuchtigkeit",
                  text: "43.80%",
                  iconColor: Colors.brown,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 40)),
            sectionTitle(context, "SUNLIGHT",
                isDark(context) ? accentColor : accentColor_d),
            Container(
              child: DaySlider(
                onValueChanged: (_timeRange) => {
                  setState(
                    () => timeRange = _timeRange,
                  ),
                  suntimeChanged(timeRange)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
