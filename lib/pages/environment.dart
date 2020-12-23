import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/environment/activeEnvironmentListItem.dart';
import 'package:sgs/customwidgets/environment/environmentListItem.dart';
import 'package:sgs/customwidgets/popupMenu.dart';
import 'package:sgs/customwidgets/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/objects/popupMenuOption.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:weather_icons/weather_icons.dart';

import '../styles.dart';
import 'editEnvironment.dart';

class Environment extends StatelessWidget {
  List<Widget> getEnvList(
      List<EnvironmentSettings> settings, EnvironmentSettings active, context) {
    List<Widget> cardlist = [];

    settings.forEach((element) {
      if (element != active)
        cardlist.add(EnvironmentListItem(settings: element));
    });
    return cardlist;
  }

  List<PopupMenuOption> options = [
    PopupMenuOption(
        "Edit",
        Icon(
          Icons.edit,
          color: primaryColor,
        )),
    PopupMenuOption(
        "Delete",
        Icon(
          Icons.delete,
          color: Colors.redAccent,
        ))
  ];

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
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
        contentPadding: false,
        body: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 20.0),
            child: sectionTitle(
                context,
                "Others",
                theme.name == "light"
                    ? theme.secondaryTextColor
                    : theme.headlineColor),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 500 > 400
                ? MediaQuery.of(context).size.height - 500
                : 400,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: getEnvList(settings, d.activeEnvironment, context),
            ),
          )
        ],
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
          backgroundColor: theme.cardColor,
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
                  padding: EdgeInsets.only(left: 30, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionTitle(
                        title: activeEnvironment.name,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      PopupMenu(
                        color: Colors.white,
                        options: options,
                        onSelected: (val) {
                          switch (val) {
                            case 'Edit':
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.leftToRightWithFade,
                                  child: EditEnvironment(
                                      initialSettings: activeEnvironment,
                                      create: false),
                                ),
                              );
                              break;
                            case 'Delete':
                              Provider.of<DashboardProvider>(context,
                                      listen: false)
                                  .deleteEnvironment(activeEnvironment);
                              break;
                            default:
                          }
                        },
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
