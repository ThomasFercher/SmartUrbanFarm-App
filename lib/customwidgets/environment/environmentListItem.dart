import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/environment/settingsListTile.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/objects/popupMenuOption.dart';
import 'package:sgs/pages/editEnvironment.dart';
import 'package:sgs/pages/environment.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../styles.dart';
import '../popupMenu.dart';

class EnvironmentListItem extends StatelessWidget {
  final EnvironmentSettings settings;
  EnvironmentListItem({@required this.settings});

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
      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: Card(
        elevation: cardElavation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: theme.cardColor,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              height: 56,
              decoration: BoxDecoration(
                color: theme.primaryColor,
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
                  PopupMenu(
                    color: Colors.white,
                    options: options,
                    onSelected: (val) {
                      switch (val) {
                        case 'Set Active':
                          Provider.of<DashboardProvider>(context, listen: false)
                              .setActiveEnvironment(settings);
                          break;
                        case 'Edit':
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.leftToRightWithFade,
                              child: EditEnvironment(
                                  initialSettings: settings, create: false),
                            ),
                          );
                          break;
                        case 'Delete':
                          Provider.of<DashboardProvider>(context, listen: false)
                              .deleteEnvironment(settings);
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
            Padding(padding: EdgeInsets.only(bottom: 10))
          ],
        ),
      ),
    );
  }
}
