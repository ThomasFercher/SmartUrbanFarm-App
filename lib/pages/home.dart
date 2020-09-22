import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/carddata.dart';
import 'package:sgs/customwidgets/dayslider.dart';
import 'package:sgs/customwidgets/actionCard.dart';
import 'package:sgs/customwidgets/waterTankLevel.dart';
import 'package:sgs/pages/advanced.dart';
import 'package:sgs/pages/environment.dart';
import 'package:sgs/pages/gallery.dart';
import 'package:sgs/pages/settings.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_icons/weather_icons.dart';

class Home extends StatelessWidget {
  static const String EnvironmentSettings = 'Environment';
  static const String Settings = 'Settings';
  static const String SignOut = 'About';

  static const List<String> choices = <String>[
    EnvironmentSettings,
    Settings,
    SignOut
  ];

  void choiceAction(String choice, context) {
    if (choice == Settings) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: Provider.of<SettingsProvider>(context),
            child: SettingsPage(),
          ),
        ),
      );
    } else if (choice == EnvironmentSettings) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: Provider.of<DashboardProvider>(context),
            child: Environment(),
          ),
        ),
      );
    } else if (choice == SignOut) {
      print('SignOut');
    }
  }

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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              AppBarHeader(
                isPage: false,
                theme: theme,
                title: "Smart Grow System",
                trailling: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.settings,
                    size: 25,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  color: Colors.white,
                  elevation: getCardElavation(context),
                  onSelected: (s) => choiceAction(s, context),
                  itemBuilder: (BuildContext context) {
                    return choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(
                          choice,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
                body: Container(
                  //margin: EdgeInsets.symmetric(horizontal: 10),

                  padding: EdgeInsets.only(left: 25, right: 25, top: 25),
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      sectionTitle(
                        context,
                        "Details",
                        theme.secondaryTextColor,
                      ),
                      GridView.count(
                        padding: EdgeInsets.all(0),
                        crossAxisSpacing: 15,
                        // mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        shrinkWrap: true,
                        children: <Widget>[
                          CardData(
                            icon: WeatherIcons.thermometer,
                            label: "Temperatur",
                            text: "$temperature°C",
                            iconColor: Colors.red[600],
                            type: Temperature,
                            key: GlobalKey(),
                          ),
                          CardData(
                            icon: WeatherIcons.humidity,
                            label: "Luftfeuchtigkeit",
                            text: "$humidity%",
                            iconColor: Colors.blue[700],
                            type: Humidity,
                            key: GlobalKey(),
                          ),
                          CardData(
                            icon: WeatherIcons.barometer,
                            label: "Bodenfeuchtigkeit",
                            text: "$soilMoisture%",
                            iconColor: Colors.brown[700],
                            type: SoilMoisture,
                            key: GlobalKey(),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      sectionTitle(
                          context,
                          "Sunlight",
                          theme.name == "light"
                              ? theme.secondaryTextColor
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
                                  "Actions",
                                  theme.name == "light"
                                      ? theme.secondaryTextColor
                                      : theme.headlineColor),
                              ActionCard(
                                width: width / 4 - 10,
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Gallery()),
                                  )
                                },
                                icon: Icons.photo,
                                text: "Gallery",
                                iconColor: theme.primaryColor,
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 5)),
                              ActionCard(
                                width: width / 4 - 10,
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Advanced()),
                                  )
                                },
                                icon: Icons.assessment,
                                text: "Advanved Data",
                                iconColor: theme.secondaryColor,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              sectionTitle(
                                  context,
                                  "Watertank",
                                  theme.name == "light"
                                      ? theme.secondaryTextColor
                                      : theme.headlineColor),
                              WaterTankLevel(
                                fullness: dashboard.waterTankLevel,
                                height: 218,
                                width: 120,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
