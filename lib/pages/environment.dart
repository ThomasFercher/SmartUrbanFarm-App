import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sgs/main.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/providers/storageProvider.dart';
import 'package:weather_icons/weather_icons.dart';

import '../styles.dart';

class Environment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: getTheme().headlineColor,
      ),
      child: Scaffold(
        floatingActionButton: Container(
          width: 64,
          height: 64,
          child: FloatingActionButton(
            onPressed: () => {},
            backgroundColor: Colors.white,
            child: Icon(
              Icons.add,
              size: 25,
              color: getTheme().background[0],
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Container(
            decoration: BoxDecoration(
              color: getTheme().background[0],
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 1.0,
                  offset: Offset(0.0, 0.75),
                )
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: AppBar(
              iconTheme: IconThemeData(color: getTheme().headlineColor),
              title: Text(
                "Environment Settings",
                style: TextStyle(color: getTheme().headlineColor),
              ),
              backgroundColor: getTheme().background[0],
              elevation: 0,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Consumer<DashboardProvider>(builder: (context, d, child) {
          List<EnvironmentSettings> settings = d.settings;
          return ListView.builder(
            itemCount: settings.length,
            itemBuilder: (context, index) {
              return EnvironmentListItem(
                settings: settings[index],
              );
            },
          );
        }),
      ),
    );
  }
}

class EnvironmentListItem extends StatelessWidget {
  final EnvironmentSettings settings;

  EnvironmentListItem({@required this.settings});

  @override
  Widget build(BuildContext context) {
    var temperature = settings.getTemperature;
    var humidity = settings.getHumidity;
    var soilMoisture = settings.getSoilMoisture;
    var suntime = settings.getSuntime;

    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.all(15),
      height: 400,
      child: Card(
        elevation: cardElavation + 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, bottom: 5, top: 5),
              child: Text(
                settings.name,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
            Divider(),
            SettingsListTile(
              icon: WeatherIcons.thermometer,
              color: Colors.redAccent,
              title: "Temperature",
              value: 25,
              onValueChanged: (v) => {print(v)},
            ),
            SettingsListTile(
              icon: WeatherIcons.humidity,
              color: Colors.blueAccent,
              title: "Humidity",
              value: 25,
              onValueChanged: (v) => {print(v)},
            ),
            SettingsListTile(
              icon: WeatherIcons.barometer,
              color: Colors.brown,
              title: "Soil Moisture",
              value: 25,
              onValueChanged: (v) => {print(v)},
            )
          ],
        ),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final Function onValueChanged;
  final Color color;

  const SettingsListTile({
    Key key,
    this.color,
    this.icon,
    this.title,
    this.value,
    this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(
                color: getTheme().textColor,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 30,
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: CustomTrackShape(),
              ),
              child: Slider(
                activeColor: color,
                inactiveColor: Colors.black26,
                //  value: getValue(label, d)["value"],
                value: 25,
                divisions: 80,
                min: 10,
                max: 50,
                onChanged: (value) => onValueChanged(value),
              ),
            ),
          ),
        ],
      ),
      leading: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: color,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      trailing: Container(
        height: 48,
        padding: EdgeInsets.only(top: 10),
        child: Text(
          "$value",
          style: TextStyle(
            color: getTheme().textColor,
            fontWeight: FontWeight.w100,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = 10;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 35;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
