import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/carddata.dart';
import 'package:sgs/customwidgets/dayslider.dart';
import 'package:sgs/customwidgets/actionCard.dart';
import 'package:sgs/customwidgets/waterTankLevel.dart';
import 'package:sgs/pages/advanced.dart';
import 'package:sgs/pages/gallery.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = getTheme();
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, child) {
        var temperature = dashboard.temperature;
        var humidity = dashboard.humidity;
        var soilMoisture = dashboard.soilMoisture;

        var width = MediaQuery.of(context).size.width - 20;
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                sectionTitle(context, "DETAILS", theme.headlineColor),
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
                sectionTitle(
                    context,
                    "SUNLIGHT",
                    theme.name == "light"
                        ? Colors.black87
                        : theme.headlineColor),
                Container(
                  child: DaySlider(
                    initialTimeString: dashboard.suntime,
                    onValueChanged: (_timeRange) =>
                        {dashboard.suntimeChanged(_timeRange)},
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle(
                            context,
                            "ACTIONS",
                            theme.name == "light"
                                ? Colors.black87
                                : theme.headlineColor),
                        ActionCard(
                          width: width / 3 - 10,
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Gallery()),
                            )
                          },
                          icon: Icons.photo,
                          text: "Gallery",
                          iconColor: Colors.deepOrange,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 5)),
                        ActionCard(
                          width: width / 3 - 10,
                          onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Advanced()),
                            )
                          },
                          icon: Icons.assessment,
                          text: "Advanved Data",
                          iconColor: Colors.deepPurple,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionTitle(
                            context,
                            "WATERTANK",
                            theme.name == "light"
                                ? Colors.black87
                                : theme.headlineColor),
                        WaterTankLevel(
                          fullness: dashboard.waterTankLevel,
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 500,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
