import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/customwidgets/detaildialog.dart';
import 'package:sgs/customwidgets/smalldatachart.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';

class CardData extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;
  final Color iconColor;
  final GlobalKey _key = new GlobalKey();

  /// This widget displays a given text with a label and icon
  /// All this is displayed in a card
  CardData({
    @required this.icon,
    @required this.text,
    @required this.label,
    @required this.iconColor,
  });

  Offset getOffset(Offset initalOffset, width, contentWidth, y2) {
    Offset offset;

    if (contentWidth - width < initalOffset.dx) {
      var newdx = initalOffset.dx - (initalOffset.dx + width - y2 + 8);
      offset = new Offset(newdx, initalOffset.dy);
    } else {
      offset = new Offset(initalOffset.dx, initalOffset.dy);
    }

    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, d, child) {
        return CupertinoContextMenu(
          actions: <Widget>[Container()],
          previewBuilder: (context, animation, child) {
            return detailedPopup(context, d);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: getCardElavation(context),
            color: getTheme().cardColor,
            child: Container(
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 20,
                      color: iconColor,
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        color: getTheme().textColor,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        color: getTheme().textColor,
                        fontWeight: FontWeight.w100,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getSmallDataChart(var name, DashboardProvider d) {
    switch (name) {
      case "Temperatur":
        return SmallDataChart(
          data: d.getTemperatures(),
          gradientColors: [Colors.red, Colors.redAccent],
        );
        break;
      case "Luftfeuchtigkeit":
        return SmallDataChart(
          data: d.getHumiditys(),
          gradientColors: [Colors.blue, Colors.blueAccent],
        );
        break;
      default:
        return Container();
    }
  }

  getValue(var name, DashboardProvider d) {
    switch (name) {
      case "Temperatur":
        return {
          "value": d.tempSoll,
          "string": d.tempSoll.toString() + "°C",
          "changed": (v) => d.tempSollChanged(v),
        };
        break;
      case "Luftfeuchtigkeit":
        return {
          "value": d.humiditySoll,
          "string": d.humiditySoll.toString() + "%",
          "changed": (v) => d.humiditySollChanged(v)
        };
        break;
      case "Bodenfeuchtigkeit":
        return {
          "value": d.soilMoistureSoll,
          "string": d.soilMoistureSoll.toString() + "%",
          "changed": (v) => d.soilMoistureSollChanged(v)
        };
        break;
      default:
        return 0.0;
    }
  }

  Widget detailedPopup(BuildContext context, DashboardProvider d) {
    return Consumer<DashboardProvider>(
      builder: (context, d, child) {
        return Container(
          margin: EdgeInsets.only(
              //  top: offsetcard.dy,
              //  left: offsetcard.dx,
              ),
          width: 258.0,
          height: 400.0,
          child: Card(
            elevation: cardElavation,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius),
              ),
            ),
            color: getTheme().cardColor,
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35,
                        width: 140,
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(bottom: 4, left: 10),
                        margin: EdgeInsets.only(top: 40),
                        child: Hero(
                          tag: label,
                          child: new Text(
                            label,
                            style: TextStyle(
                              color: getTheme().textColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 110,
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(right: 10),
                        margin: EdgeInsets.only(top: 40),
                        child: Hero(
                          tag: text,
                          child: new Text(
                            text,
                            style: TextStyle(
                              color: getTheme().textColor,
                              fontWeight: FontWeight.w100,
                              fontSize: 30.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Sollwert",
                              style: TextStyle(
                                color: getTheme().textColor,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 150,
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackShape: CustomTrackShape(),
                              ),
                              child: Slider(
                                activeColor: iconColor,
                                inactiveColor: iconColor,
                                value: getValue(label, d)["value"],
                                divisions: 80,
                                min: 10,
                                max: 50,
                                onChanged: (value) {
                                  getValue(label, d)["changed"](value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 35,
                        width: 100,
                        alignment: Alignment.bottomRight,
                        padding: EdgeInsets.only(bottom: 0, right: 10),
                        child: new Text(
                          getValue(label, d)["string"],
                          style: TextStyle(
                            color: getTheme().textColor,
                            fontWeight: FontWeight.w100,
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black12,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    width: 258,
                    height: 200,
                    child: getSmallDataChart(
                      label,
                      d,
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 60,
                  height: 60,
                  transform: Matrix4.translationValues(0, -30, 0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        color: iconColor,
                      ),
                      child: new Icon(
                        icon,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = 10;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 35;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
