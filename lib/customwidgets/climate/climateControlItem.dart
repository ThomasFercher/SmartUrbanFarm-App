import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/climate/settingsListTile.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/objects/climateControl.dart';
import 'package:sgs/objects/popupMenuOption.dart';
import 'package:sgs/pages/editEnvironment.dart';
import 'package:sgs/pages/environment.dart';
import 'package:sgs/providers/dataProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../styles.dart';
import '../general/popupMenu.dart';

class ClimateControlItem extends StatelessWidget {
  final ClimateControl settings;
  ClimateControlItem({@required this.settings});

  List<PopupMenuOption> options = [
    PopupMenuOption(
        "Set Active",
        Icon(
          Icons.check,
          color: primaryColor,
        )),
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
    var temperature = settings.getTemperature;
    var humidity = settings.getHumidity;
    var soilMoisture = settings.getSoilMoisture;
    var suntime = settings.getSuntime;
    var waterConsumption = settings.getWaterConsumption;
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: OpenContainer(
        closedColor: theme.background,
        closedElevation: 0.0,
        openBuilder: (_, closeContainer) {
          return EditEnvironment(
            initialSettings: settings,
            create: false,
          );
        },
        closedBuilder: (_, openContainer) {
          return LayoutBuilder(
            builder: (context, constraints) {
              print(constraints.maxHeight);
              var itemheight =
                  ((constraints.maxHeight - 24) / 6).roundToDouble();

              return Card(
                elevation: cardElavation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: theme.cardColor,
                child: Container(
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    itemExtent: itemheight,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 15),
                                child: SectionTitle(
                                  title: settings.name,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            PopupMenu(
                              color: Colors.white,
                              options: options,
                              onSelected: (val) {
                                switch (val) {
                                  case 'Set Active':
                                    Provider.of<DataProvider>(context,
                                            listen: false)
                                        .setActiveClimate(settings);
                                    break;
                                  case 'Edit':
                                    openContainer();
                                    break;
                                  case 'Delete':
                                    Provider.of<DataProvider>(context,
                                            listen: false)
                                        .deleteClimate(settings);
                                    break;
                                  default:
                                }
                              },
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
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
