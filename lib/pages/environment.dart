import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/general/appBarHeader.dart';
import 'package:sgs/customwidgets/climate/activeClimateControlItem.dart';
import 'package:sgs/customwidgets/climate/climateControlItem.dart';
import 'package:sgs/customwidgets/general/popupMenu.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/objects/climateControl.dart';
import 'package:sgs/objects/growPhase.dart';
import 'package:sgs/objects/popupMenuOption.dart';
import 'package:sgs/providers/dataProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';

import '../styles.dart';
import 'editEnvironment.dart';

class Environment extends StatelessWidget {
  List<Widget> getEnvList(
      List<ClimateControl> climates, ClimateControl active, context) {
    List<Widget> cardlist = [];

    climates.forEach((element) {
      if (element.getID != active.getID)
        cardlist.add(ClimateControlItem(settings: element));
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
  ];

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    var height = MediaQuery.of(context).size.height / 2;
    print(height);
    height = height > 400 ? 400 : height;
    var h2 = MediaQuery.of(context).size.height - height - 32;
    print(h2);
    return Consumer<DataProvider>(builder: (context, d, child) {
      List<ClimateControl> climates = d.climates;
      ClimateControl activeClimate = d.activeClimate;
      var temp = activeClimate.getTemperature(GROWPHASEFLOWER);
      var hum = activeClimate.getHumidity(GROWPHASEFLOWER);
      var soil = activeClimate.soilMoisture;
      var sun = activeClimate.getSuntime(GROWPHASEFLOWER);
      var water = activeClimate.waterConsumption;
      return AppBarHeader(
        isPage: true,
        title: "Climate Control",
        contentPadding: false,
        bottomBarColor: theme.background,
        body: [
          Container(
            height: h2,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: getEnvList(climates, d.activeClimate, context),
            ),
          )
        ],
        actionButton: OpenContainer(
          closedBuilder: (_, openContainer) {
            return FloatingActionButton(
              onPressed: openContainer,
              backgroundColor: theme.cardColor,
              child: Icon(Icons.add, color: primaryColor),
              elevation: 2.0,
            );
          },
          closedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(100))),
          closedColor: theme.background,
          openBuilder: (_, closeContainer) {
            return EditEnvironment(
              initialSettings: new ClimateControl(
                  name: "",
                  soilMoisture: 0,
                  waterConsumption: 0,
                  automaticWatering: true,
                  growPhase: new GrowPhase(
                    flower_hum: 50.0,
                    flower_suntime: "06:00 - 18:00",
                    flower_temp: 10.0,
                    vegation_hum: 50.0,
                    vegation_temp: 10.0,
                    vegation_suntime: "06:00 - 18:00",
                    lateflower_hum: 50.0,
                    lateflower_temp: 10.0,
                    lateflower_suntime: "06:00 - 18:00",
                  )),
              create: true,
            );
          },
        ),
        appbarBottom: PreferredSize(
          preferredSize: Size.fromHeight(height),
          child: OpenContainer(
              closedElevation: 0.0,
              closedColor: primaryColor,
              openBuilder: (_, closeContainer) {
                return EditEnvironment(
                  initialSettings: activeClimate,
                  create: false,
                );
              },
              closedBuilder: (_, openContainer) {
                return Container(
                  height: height - 60,
                  child: ListView(
                    itemExtent: (height - 80) / 5,
                    children: [
                      ListTile(
                          contentPadding: EdgeInsets.only(left: 15, right: 0),
                          title: SectionTitle(
                            title: activeClimate.name,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                          trailing: PopupMenu(
                            color: Colors.white,
                            options: options,
                            onSelected: (val) {
                              switch (val) {
                                case 'Edit':
                                  openContainer();
                                  break;

                                default:
                              }
                            },
                          )),
                      ActiveClimateControlItem(
                        icon: WeatherIcons.wi_thermometer,
                        lable: "Temperature",
                        value: "$temp°C",
                      ),
                      ActiveClimateControlItem(
                        icon: WeatherIcons.wi_humidity,
                        lable: "Humidity",
                        value: "$hum%",
                      ),
                      activeClimate.automaticWatering
                          ? ActiveClimateControlItem(
                              icon: WeatherIcons.wi_barometer,
                              lable: "Soil Moisture",
                              value: "$soil%",
                            )
                          : ActiveClimateControlItem(
                              icon: WeatherIcons.wi_day_rain,
                              lable: "Water Consumption",
                              value: "$water" + "l/d",
                            ),
                      ActiveClimateControlItem(
                        icon: WeatherIcons.wi_day_sunny,
                        lable: "Suntime",
                        value: sun,
                      ),
                    ],
                  ),
                );
              }),
        ),
      );
    });
  }
}
