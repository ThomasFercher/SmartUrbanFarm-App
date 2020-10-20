import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/carddata.dart';
import 'package:sgs/customwidgets/dayRange.dart';
import 'package:sgs/customwidgets/dayslider.dart';
import 'package:sgs/customwidgets/actionCard.dart';
import 'package:sgs/customwidgets/growProgress.dart';
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
import 'advanced.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sgs/objects/appTheme.dart';
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
        return AppBarHeader(
          isPage: false,
          theme: theme,
          title: "Smart Grow Farm",
          contentPadding: true,
          body: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20)),
            sectionTitle(
              context,
              "Details",
              theme.secondaryTextColor,
            ),
            GridView.count(
              primary: false,
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
                  iconColor: theme.primaryColor,
                  type: Temperature,
                  key: GlobalKey(),
                ),
                CardData(
                  icon: WeatherIcons.humidity,
                  label: "Luftfeuchtigkeit",
                  text: "$humidity%",
                  iconColor: theme.primaryColor,
                  type: Humidity,
                  key: GlobalKey(),
                ),
                CardData(
                  icon: WeatherIcons.barometer,
                  label: "Bodenfeuchtigkeit",
                  text: "$soilMoisture%",
                  iconColor: theme.primaryColor,
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
              child:
                  /*DaySlider(
                initialTimeString: dashboard.suntime,
                onValueChanged: (_timeRange) =>
                    {dashboard.suntimeChanged(_timeRange)},
              ),*/
                  DayRange(),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            sectionTitle(
                context,
                "Actions",
                theme.name == "light"
                    ? theme.secondaryTextColor
                    : theme.headlineColor),
            GridView.count(
              primary: false,
              crossAxisCount: 2,
              padding: EdgeInsets.all(0),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              // mainAxisSpacing: 10,

              childAspectRatio: 1.75,
              shrinkWrap: true,
              children: [
                ActionCard(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRightWithFade,
                          child: Gallery()),
                    )
                  },
                  icon: Icons.photo,
                  text: "Gallery",
                  iconColor: theme.primaryColor,
                  backgroundColor: Color(0xFFdcf8ec),
                ),
                ActionCard(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          child: Advanced()),
                    ),
                  },
                  icon: Icons.assessment,
                  text: "Advanced Data",
                  iconColor: theme.primaryColor,
                backgroundColor: Color(0xFFdcf8ec),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            sectionTitle(
                context,
                "Settings",
                theme.name == "light"
                    ? theme.secondaryTextColor
                    : theme.headlineColor),
            GridView.count(
              primary: false,
              crossAxisCount: 2,
              padding: EdgeInsets.all(0),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              // mainAxisSpacing: 10,

              childAspectRatio: 1.75,
              shrinkWrap: true,
              children: [
                ActionCard(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRightWithFade,
                          child: Environment()),
                    ),
                  },
                  icon: Icons.settings_system_daydream,
                  text: "Environment",
                  iconColor: theme.secondaryColor,
                  backgroundColor: Color(0xFFe1e4f4),
                ),
                ActionCard(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.leftToRightWithFade,
                        child: SettingsPage(),
                      ),
                    ),
                  },
                  icon: Icons.settings,
                  text: "App Settings",
                  iconColor: theme.secondaryColor,
                  backgroundColor: Color(0xFFe1e4f4),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            GridView.count(
              primary: false,
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 15,
              children: [
                LayoutBuilder(builder: (context, c) {
                  return Column(
                    children: [
                      sectionTitle(
                          context,
                          "Grow Progress",
                          theme.name == "light"
                              ? theme.secondaryTextColor
                              : theme.headlineColor),
                      GrowProgress(c, 100.0)
                    ],
                  );
                }),
                LayoutBuilder(builder: (context, c) {
                  return Column(
                    children: [
                      sectionTitle(
                          context,
                          "Watertank",
                          theme.name == "light"
                              ? theme.secondaryTextColor
                              : theme.headlineColor),
                      WaterTankLevel(
                        fullness: dashboard.waterTankLevel,
                        height: c.maxHeight - 46,
                      ),
                    ],
                  );
                })
              ],
            )
          ],
        );
      },
    );
  }
}
