import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sgs/customwidgets/dayslider.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';

class Home extends StatefulWidget {
  var temperature;
  var humidity;
  Home({this.temperature, this.humidity});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var timeRange = [];
  var temp;
  var humidity;
  Timer updateTimer;

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
    super.initState();
    // defines a timer
    if (this.mounted) {
      updateTimer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
        final ref = fb.reference();
        await ref.child("temperature").once().then((DataSnapshot data) {
          setState(() {
            temp = data.value;
          });
        });
        await ref.child("humidity").once().then((DataSnapshot data) {
          setState(() {
            humidity = data.value;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                text: "43.8%",
              ),
              CardData(
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
              ),
            ],
          ),
          Container(
            child: DaySlider(
              f: (t) => setState(
                () => timeRange = t,
              ),
            ),
          ),
        ],
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
      child: InkWell(
        onLongPress: () => temperatureDiagram(context),
        borderRadius: BorderRadius.circular(borderRadius),
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
      ),
    );
  }

  Future temperatureDiagram(context) {
    return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: SimpleDialog(
              backgroundColor: accentColor_d,
              elevation: getCardElavation(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius + 10)),
              title: Text('Temperaturverlauf'),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25),
                  width: 400,
                  child: new Text("Diagram"),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: FlatButton(
                    onPressed: () => print("yee"),
                    child: new Text("Show Diagram"),
                    // color: Colors.black,
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: new Text("Close"),
                    // color: Colors.black,
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {},
    );
  }
}
