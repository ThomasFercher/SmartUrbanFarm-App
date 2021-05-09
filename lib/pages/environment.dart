import 'dart:async';
import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import '../customwidgets/climate/bottom/climateControlItem.dart';
import '../customwidgets/climate/top/activeClimateControlItem.dart';
import '../customwidgets/climate/top/growPhaseSelect.dart';
import '../customwidgets/general/appBarHeader.dart';
import '../customwidgets/general/popupMenu.dart';
import '../customwidgets/general/sectionTitle.dart';
import '../objects/appTheme.dart';
import '../objects/climateControl.dart';
import '../objects/growPhase.dart';
import '../objects/popupMenuOption.dart';
import '../providers/dataProvider.dart';
import '../providers/settingsProvider.dart';
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

  int phaseIndex;
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
    phaseIndex = 1;
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
    return Consumer<DataProvider>(builder: (context, d, child) {
      List<ClimateControl> climates = d.climates;
      ClimateControl activeClimate = d.activeClimate;
      var temp = activeClimate.getTemperature(activeClimate.growPhase.phase);
      var hum = activeClimate.getHumidity(activeClimate.growPhase.phase);
      var sun = activeClimate.getSuntime(activeClimate.growPhase.phase);

      var width = MediaQuery.of(context).size.width - 24;
      width = width.floorToDouble();
      return AppBarHeader(
        isPage: true,
        title: "Climate Control",
        contentPadding: false,
        bottomBarColor: theme.background,
        scrollController: controller,
        body: [
          Container(
            color: theme.primaryColor,
            constraints:
                BoxConstraints(maxHeight: h, minHeight: 100, maxWidth: width),
            height: h,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
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
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(borderRadius),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white24,
                                ],
                                stops: [0, 0.8],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            margin: EdgeInsets.only(bottom: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 60,
                                        alignment: Alignment.centerLeft,
                                        child: SectionTitle(
                                          title: activeClimate.name,
                                          color: Colors.white,
                                          fontSize: 28,
                                        ),
                                      ),
                                    ),
                                    PopupMenu(
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
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: SectionTitle(
                                        title: "Active Growphase",
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GrowPhaseSelect(
                                            phase: GROWPHASEVEGETATION,
                                            disabledWidth:
                                                (width - 16) * 0.2 + 4,
                                            color: Colors.deepPurple,
                                            title: "Vegetation",
                                            expandedWidth:
                                                (width - 16) * 0.6 - 6,
                                            right_phase: GROWPHASEFLOWER,
                                            icon: MaterialCommunityIcons.sprout,
                                          ),
                                          GrowPhaseSelect(
                                            disabledWidth:
                                                (width - 16) * 0.2 + 4,
                                            expandedWidth:
                                                (width - 16) * 0.6 - 6,
                                            title: "Early Flower",
                                            color: Colors.green,
                                            phase: GROWPHASEFLOWER,
                                            left_phase: GROWPHASEVEGETATION,
                                            right_phase: GROWPHASELATEFLOWER,
                                            icon: MaterialCommunityIcons.sprout,
                                          ),
                                          GrowPhaseSelect(
                                            left_phase: GROWPHASEFLOWER,
                                            phase: GROWPHASELATEFLOWER,
                                            title: "Late Flower",
                                            color: Colors.amber,
                                            disabledWidth:
                                                (width - 16) * 0.2 + 4,
                                            expandedWidth:
                                                (width - 16) * 0.6 - 6,
                                            icon: MaterialCommunityIcons.sprout,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ActiveClimateControlItem(
                                          height: 60,
                                          icon: WeatherIcons.wi_thermometer,
                                          lable: "Temperature",
                                          value: "$temp°C",
                                        ),
                                        ActiveClimateControlItem(
                                          height: 60,
                                          icon: WeatherIcons.wi_humidity,
                                          lable: "Humidity",
                                          value: "$hum%",
                                        ),
                                        ActiveClimateControlItem(
                                          icon: WeatherIcons.wi_day_sunny,
                                          height: 60,
                                          lable: "Suntime",
                                          value: "$sun",
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: SectionTitle(
                                        title: "Irrigation",
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      child: Row(
                                        children: [
                                          activeClimate.automaticWatering
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
                                                    Icons.auto_awesome,
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
                                                  backgroundColor:
                                                      theme.secondaryColor,
                                                  avatar: Icon(
                                                    Icons.tune,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                activeClimate.automaticWatering
                                                    ? "${activeClimate.soilMoisture}%"
                                                    : "${activeClimate.waterConsumption}l/d",
                                                style: TextStyle(
                                                  color: Colors.white,
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
                              ],
                            ),
                          );
                        }),
                  ),
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
          duration: Duration(milliseconds: 200),
          alignment: Alignment.lerp(Alignment(0.0, 0),
              Alignment(1.0, isTop ? 1.0 - 20 / h : -1 + 96 / h), 1.0),
          child: OpenContainer(
            tappable: false,
            openColor: theme.background,
            closedBuilder: (_, openContainer) {
              return AnimatedCrossFade(
                secondChild: InkWell(
                  onTap: openContainer,
                  child: Container(
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
                ),
                firstChild: Container(
                  height: 64,
                  width: 64,
                  color: theme.background,
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
                duration: Duration(milliseconds: 200),
                crossFadeState: isTop
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              );
            },
            closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(64))),
            closedColor: theme.background,
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
