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
import 'package:sgs/customwidgets/sectionTitle.dart';
import 'package:sgs/main.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/providers/storageProvider.dart';
import 'package:weather_icons/weather_icons.dart';

import '../styles.dart';
import 'editEnvironment.dart';

class Environment extends StatelessWidget {
  List<Widget> getEnvList(
      List<EnvironmentSettings> settings, EnvironmentSettings active, context) {
    AppTheme theme = getTheme();
    List<Widget> cardlist = [];

    cardlist.add(
      Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: sectionTitle(
            context,
            "Others",
            theme.name == "light"
                ? theme.secondaryTextColor
                : theme.headlineColor),
      ),
    );
    settings.forEach((element) {
      if (element != active)
        cardlist.add(EnvironmentListItem(settings: element));
    });
    return cardlist;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, d, child) {
      List<EnvironmentSettings> settings = d.environments;
      EnvironmentSettings activeEnvironment = d.activeEnvironment;
      var temp = activeEnvironment.temperature;
      var hum = activeEnvironment.humidity;
      var soil = activeEnvironment.soilMoisture;
      var sun = activeEnvironment.suntime;
      var water = activeEnvironment.waterConsumption;
      return AppBarHeader(
        isPage: true,
        title: "Environment Settings",
        theme: getTheme(),
        body: getEnvList(settings, d.activeEnvironment, context),
        actionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              child: EditEnvironment(
                initialSettings: new EnvironmentSettings(
                  name: "",
                  temperature: 0,
                  humidity: 0,
                  soilMoisture: 0,
                  suntime: "06:00 - 18:00",
                  waterConsumption: 0,
                ),
                create: true,
              ),
            ),
          ),
          child: Icon(
            Icons.add,
            color: primaryColor,
          ),
        ),
        appbarBottom: PreferredSize(
          preferredSize: Size.fromHeight(360),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionTitle(
                        title: activeEnvironment.name,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      EnvironmentActionsDropdown(
                        activeEnvironment: activeEnvironment,
                      ),
                    ],
                  ),
                ),
                ActiveEnvironmentListItem(
                  icon: WeatherIcons.thermometer,
                  lable: "Temperature",
                  value: "$temp°C",
                ),
                ActiveEnvironmentListItem(
                  icon: WeatherIcons.humidity,
                  lable: "Humidity",
                  value: "$hum%",
                ),
                ActiveEnvironmentListItem(
                  icon: WeatherIcons.barometer,
                  lable: "Soil Moisture",
                  value: "$soil",
                ),
                ActiveEnvironmentListItem(
                  icon: WeatherIcons.day_sunny,
                  lable: "Suntime",
                  value: sun,
                ),
                ActiveEnvironmentListItem(
                  icon: WeatherIcons.rain,
                  lable: "Water Consumption",
                  value: "$water" + "l/d",
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

class EnvironmentActionsDropdown extends StatelessWidget {
  const EnvironmentActionsDropdown({
    Key key,
    @required this.activeEnvironment,
  }) : super(key: key);

  final EnvironmentSettings activeEnvironment;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        elevation: 1,
        icon: Icon(
          Icons.more_horiz,
          color: Colors.white,
          size: 28,
        ),
        items: <String>['Set Active', 'Edit', 'Delete'].map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (actions) {
          switch (actions) {
            case 'Set Active':
              Provider.of<DashboardProvider>(context, listen: false)
                  .setActiveEnvironment(activeEnvironment);
              break;
            case 'Edit':
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  child: EditEnvironment(
                      initialSettings: activeEnvironment, create: false),
                ),
              );
              break;
            case 'Delete':
              Provider.of<DashboardProvider>(context, listen: false)
                  .deleteEnvironment(activeEnvironment);
              break;
            default:
          }
        },
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
    var waterConsumption = settings.getWaterConsumption;

    return Container(
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Card(
        elevation: cardElavation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: 56,
              decoration: BoxDecoration(
                color: getTheme().primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        settings.name,
                        style: GoogleFonts.nunito(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: borderRadius),
                    child: EnvironmentActionsDropdown(
                      activeEnvironment: settings,
                    ),
                  ),
                ],
              ),
            ),
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
  final Text subtitle;

  const SettingsListTile({
    Key key,
    this.color,
    this.icon,
    this.title,
    this.value,
    this.value_text,
    this.unit,
    this.subtitle,
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
      subtitle: subtitle ?? null,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: getTheme().textColor.withOpacity(0.03)),
        child: Icon(
          icon,
          color: color,
          size: 18,
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

class ActiveEnvironmentListItem extends StatelessWidget {
  final String value;
  final String lable;
  final IconData icon;
  final double height;

  const ActiveEnvironmentListItem(
      {Key key, this.value, this.lable, this.icon, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 38,
            width: 38,
            margin: const EdgeInsets.only(right: 15, bottom: 3, top: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.2),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              lable,
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
