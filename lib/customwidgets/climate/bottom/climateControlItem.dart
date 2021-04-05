import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../objects/appTheme.dart';
import '../../../objects/climateControl.dart';
import '../../../objects/popupMenuOption.dart';
import '../../../pages/editEnvironment.dart';
import '../../../providers/dataProvider.dart';
import '../../../providers/settingsProvider.dart';
import '../../../styles.dart';
import '../../general/popupMenu.dart';
import '../../general/sectionTitle.dart';
import 'verticalListTile.dart';

class ClimateControlItem extends StatelessWidget {
  final ClimateControl settings;
  ClimateControlItem({@required this.settings});

  List<PopupMenuOption> options = [
    PopupMenuOption(
      "Set Active",
      Icon(
        Icons.check,
        color: primaryColor,
      ),
    ),
    PopupMenuOption(
      "Edit",
      Icon(
        Icons.edit,
        color: primaryColor,
      ),
    ),
    PopupMenuOption(
      "Delete",
      Icon(
        Icons.delete,
        color: Colors.redAccent,
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return Container(
      // height: 400,

      width: MediaQuery.of(context).size.width - 30,
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: OpenContainer(
        closedColor: theme.background,
        closedElevation: 0.0,
        tappable: false,
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
              var h = constraints.maxHeight - 68;
              var w = constraints.maxWidth - 2 * borderRadius;

              return Card(
                elevation: cardElavation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                color: theme.cardColor,
                child: Container(
                  height: h - 8,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(borderRadius),
                              topRight: Radius.circular(borderRadius)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 15),
                                child: SectionTitle(
                                  title: settings.name,
                                  color: Colors.white,
                                  fontSize: 24,
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
                      Container(
                        height: h,
                        padding: EdgeInsets.symmetric(
                          horizontal: borderRadius,
                          vertical: 10,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: SectionTitle(
                                title: "Grow Phases",
                                fontSize: 20,
                                color: theme.headlineColor,
                              ),
                              padding: EdgeInsets.only(bottom: 8),
                            ),
                            Expanded(
                              child: Container(
                                width: w,
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return GridView.count(
                                    primary: false,
                                    crossAxisCount: 3,
                                    childAspectRatio:
                                        (w / 3) / (constraints.maxHeight),
                                    padding: EdgeInsets.all(0),
                                    crossAxisSpacing: borderRadius / 2,
                                    children: [
                                      VerticalListTile(
                                        title: "Vegetation",
                                        color: Colors.deepPurple,
                                        humidity:
                                            settings.growPhase.vegation_hum,
                                        temperature:
                                            settings.growPhase.vegation_temp,
                                        suntime:
                                            settings.growPhase.vegation_suntime,
                                      ),
                                      VerticalListTile(
                                        title: "Early Flower",
                                        color: Colors.green,
                                        humidity: settings.growPhase.flower_hum,
                                        temperature:
                                            settings.growPhase.flower_temp,
                                        suntime:
                                            settings.growPhase.flower_suntime,
                                      ),
                                      VerticalListTile(
                                        title: "Late Flower",
                                        color: Colors.amber,
                                        humidity:
                                            settings.growPhase.lateflower_hum,
                                        temperature:
                                            settings.growPhase.lateflower_temp,
                                        suntime: settings
                                            .growPhase.lateflower_suntime,
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 8.0),
                              alignment: Alignment.centerLeft,
                              child: SectionTitle(
                                title: "Irrigation",
                                fontSize: 20,
                                color: theme.headlineColor,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  settings.automaticWatering
                                      ? Chip(
                                          label: Container(
                                            height: 34,
                                            alignment: Alignment.center,
                                            child: SectionTitle(
                                              fontSize: 14,
                                              title: "Automatic",
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: primaryColor,
                                          avatar: Icon(
                                            Icons.tune,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Chip(
                                          label: Container(
                                            height: 32,
                                            alignment: Alignment.center,
                                            child: SectionTitle(
                                              fontSize: 14,
                                              title: "Regulated",
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor: theme.secondaryColor,
                                          avatar: Icon(
                                            Icons.tune,
                                            color: Colors.white,
                                          ),
                                        ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        settings.automaticWatering
                                            ? "${settings.soilMoisture}%"
                                            : "${settings.waterConsumption}l/d",
                                        style: TextStyle(
                                          color: theme.textColor,
                                          fontWeight: FontWeight.w100,
                                          fontSize: 28.0,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
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
