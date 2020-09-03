import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/carddata.dart';
import 'package:sgs/customwidgets/dayslider.dart';
import 'package:sgs/customwidgets/pictureTaker.dart';
import 'package:sgs/customwidgets/waterTankLevel.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, child) {
        var temperature = dashboard.temperature;
        var humidity = dashboard.humidity;
        var soilMoisture = dashboard.soilMoisture;

        return Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            shrinkWrap: true,
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
                    text: "$temperature°C",
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
                    text: "$soilMoisture%",
                    iconColor: Colors.brown,
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 40)),
              sectionTitle(context, "SUNLIGHT",
                  isDark(context) ? accentColor : accentColor_d),
              Container(
                child: DaySlider(
                  initialTimeString: dashboard.suntime,
                  onValueChanged: (_timeRange) =>
                      {dashboard.suntimeChanged(_timeRange)},
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle(context, "ACTIONS",
                          isDark(context) ? accentColor : accentColor_d),
                      PictureTaker(onPressed: null)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle(context, "WATERTANK",
                          isDark(context) ? accentColor : accentColor_d),
                      WaterTankLevel(
                        fullness: dashboard.waterTankLevel,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
