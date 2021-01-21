import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class Environment extends StatefulWidget {
  final double height;

  const Environment({Key key, this.height}) : super(key: key);

  @override
  _EnvironmentState createState() => _EnvironmentState();
}

class _EnvironmentState extends State<Environment> {
  List<Widget> getEnvList(
      List<ClimateControl> climates, ClimateControl active, context) {
    List<Widget> cardlist = [];

    climates.forEach((element) {
      if (element.getID != active.getID)
        cardlist.add(ClimateControlItem(settings: element));
    });
    return cardlist;
  }

  bool isTop;
  ScrollController controller;

  List<PopupMenuOption> options = [
    PopupMenuOption(
        "Edit",
        Icon(
          Icons.edit,
          color: primaryColor,
        )),
  ];

  @override
  void initState() {
    isTop = true;
    controller = new ScrollController();

    controller.addListener(() {
      var scrollOffset = controller.position.pixels;
      var scrollDirection = controller.position.userScrollDirection;
      print(scrollOffset);
      print(widget.height);
      if (scrollOffset > (widget.height * 0.6) &&
          scrollDirection == ScrollDirection.forward &&
          isTop == false) {
        Timer(
          Duration(milliseconds: 1),
          () async => await controller.animateTo(0,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
        );
        setState(() {
          isTop = true;
        });
      } else if (scrollOffset > 0 &&
          scrollOffset < widget.height * 0.8 &&
          scrollDirection == ScrollDirection.reverse &&
          isTop == true) {
        Timer(
          Duration(milliseconds: 1),
          () async => await controller.animateTo(widget.height * 1.5,
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
        );
        setState(() {
          isTop = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    var h = widget.height * 0.8;
    var height = MediaQuery.of(context).size.height / 2;

    print("a$height");

    var h2 = h;

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
        scrollController: controller,
        body: [
          Container(
            color: theme.primaryColor,
            constraints: BoxConstraints(maxHeight: h, minHeight: 100),
            height: h,
            child: Column(
              children: [
                Expanded(
                  child: OpenContainer(
                      tappable: false,
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
                          child: ListView(
                            shrinkWrap: true,
                            primary: false,
                            itemExtent: (height - 80) / 5,
                            children: [
                              ListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: 15, right: 0),
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
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: isTop ? 0.0 : h * 0.2,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 150),
                    opacity: isTop ? 0.0 : 1.0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: InkWell(
                        onTap: () {
                          Timer(
                            Duration(milliseconds: 1),
                            () async => await controller.animateTo(0,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut),
                          );
                          setState(() {
                            isTop = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SectionTitle(
                                title: "Active",
                                fontSize: 22,
                                color: Colors.white,
                              ),
                              Icon(
                                MaterialIcons.keyboard_arrow_up,
                                size: 64,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: widget.height * 0.8,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.only(top: isTop ? h * 0.2 : 0),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: getEnvList(climates, d.activeClimate, context),
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 150),
                  opacity: isTop ? 1.0 : 0.0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: InkWell(
                      onTap: () {
                        Timer(
                          Duration(milliseconds: 1),
                          () async => await controller.animateTo(
                            widget.height * 1.6,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                        );
                        setState(() {
                          isTop = false;
                        });
                      },
                      child: Container(
                        height: h * 0.2,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SectionTitle(
                              title: "Others",
                              fontSize: 22,
                              color: theme.primaryColor,
                            ),
                            Icon(
                              MaterialIcons.keyboard_arrow_down,
                              size: 64,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
        actionButton: AnimatedAlign(
          duration: Duration(milliseconds: 300),
          alignment: Alignment.lerp(Alignment(0.0, 0),
              Alignment(1.0, isTop ? 0.8 - 84 / h : -1 + 96 / h), 1.0),
          child: OpenContainer(
            tappable: false,
            closedBuilder: (_, openContainer) {
              return AnimatedCrossFade(
                secondChild: Container(
                  width: 96,
                  height: 48,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: theme.primaryColor,
                        size: 24,
                      ),
                      SectionTitle(
                        title: "Add",
                        fontSize: 18,
                        color: theme.primaryColor,
                      )
                    ],
                  ),
                ),
                firstChild: Container(
                  height: 64,
                  width: 64,
                  child: FloatingActionButton(
                    onPressed: openContainer,
                    backgroundColor: theme.cardColor,
                    child: Icon(
                      Icons.add,
                      color: primaryColor,
                      size: 28,
                    ),
                    elevation: 2.0,
                  ),
                ),
                duration: Duration(milliseconds: 300),
                crossFadeState: isTop
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              );
            },
            closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(64))),
            closedColor: theme.primaryColor,
            closedElevation: 0,
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
                  ),
                ),
                create: true,
              );
            },
          ),
        ),
      );
    });
  }
}
