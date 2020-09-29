import 'dart:async';
import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/main.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/providers/storageProvider.dart';
import 'package:weather_icons/weather_icons.dart';

import '../styles.dart';
import 'editEnvironment.dart';

class Environment extends StatelessWidget {
  List<Widget> getEnvList(List<EnvironmentSettings> settings) {
    List<Widget> cardlist = [];
    settings.forEach((element) {
      cardlist.add(EnvironmentListItem(settings: element));
    });
    return cardlist;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, d, child) {
      List<EnvironmentSettings> settings = d.settings;
      return AppBarHeader(
        isPage: true,
        title: "Environment Settings",
        theme: getTheme(),
        body: getEnvList(settings),
      );
    });
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
    var waterConsumption = settings.getWaterConsumption;

    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.only(top: 20),
      child: Card(
        elevation: cardElavation,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        color: Colors.white,
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, bottom: 5, top: 5),
                  child: Text(
                    settings.name,
                    style: GoogleFonts.nunito(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: borderRadius),
                  decoration: BoxDecoration(
                    color: getTheme().primaryColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  height: 36,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 18),
                        child: Text(
                          "Edit",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: EditEnvironment(settings: settings),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            SettingsListTile(
              icon: WeatherIcons.thermometer,
              color: Colors.redAccent,
              title: "Temperature",
              value: temperature,
              unit: "°C",
            ),
            SettingsListTile(
              icon: WeatherIcons.humidity,
              color: Colors.blueAccent,
              title: "Humidity",
              value: humidity,
              unit: "%",
            ),
            SettingsListTile(
              icon: WeatherIcons.barometer,
              color: Colors.green,
              title: "Soil Moisture",
              value: soilMoisture,
              unit: "%",
            ),
            SettingsListTile(
              icon: WeatherIcons.sunrise,
              color: Colors.orange[400],
              title: "Suntime",
              value_text: suntime,
              unit: "",
            ),
            SettingsListTile(
              icon: WeatherIcons.rain,
              color: Colors.lightBlue,
              title: "Water Consumption",
              value: waterConsumption,
              unit: "l/d",
            ),
            Padding(padding: EdgeInsets.only(bottom: 10))
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
  final String value_text;
  final Color color;
  final String unit;

  const SettingsListTile({
    Key key,
    this.color,
    this.icon,
    this.title,
    this.value,
    this.value_text,
    this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var val = value ?? value_text;
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: getTheme().textColor,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text("Sollwert"),
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
          "$val$unit",
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
