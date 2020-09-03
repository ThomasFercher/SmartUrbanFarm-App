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
        return GestureDetector(
          onLongPress: () {
            RenderBox renderBoxRed = _key.currentContext.findRenderObject();
            var offsetcard = renderBoxRed.localToGlobal(Offset.zero);
            var y2 = offsetcard.dx + renderBoxRed.size.width;

            offsetcard = getOffset(
                offsetcard, 250, MediaQuery.of(context).size.width, y2);

            Navigator.of(context).push(
              new PageRouteBuilder(
                opaque: false,
                barrierDismissible: true,
                pageBuilder: (BuildContext context, _, __) {
                  Tween<double> _tween = Tween(
                    begin: 0.46,
                    end: 1,
                  );

                  return detailedPopup(offsetcard, context, _, _tween, d);
                },
              ),
            );
          },
          child: Card(
            key: _key,
            elevation: getCardElavation(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            color: isDark(context) ? accentColor_d : Colors.white,
            child: Container(
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: icon.codePoint,
                      child: Icon(
                        icon,
                        size: 20,
                        color: iconColor,
                      ),
                    ),
                    Hero(
                      tag: label,
                      child: new Text(
                        label,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Hero(
                      tag: text,
                      child: new Text(
                        text,
                        style: Theme.of(context).textTheme.headline1,
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

  Widget detailedPopup(Offset offsetcard, BuildContext context,
      Animation<double> _, Tween<double> _tween, DashboardProvider d) {
    return Consumer<DashboardProvider>(
      builder: (context, d, child) {
        return GestureDetector(
          onTapUp: (details) {
            if (!Rect.fromLTWH(offsetcard.dx, offsetcard.dy, 258, 300)
                .contains(details.globalPosition)) {
              Navigator.of(context).pop();
            }
          },
          child: Container(
            color: Colors.black.withOpacity(0.5),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(
                  top: offsetcard.dy,
                  left: offsetcard.dx,
                ),
                width: 258.0,
                height: 400.0,
                child: ScaleTransition(
                  scale: _tween.animate(
                    new CurvedAnimation(parent: _, curve: Curves.easeOut),
                  ),
                  alignment: Alignment.topLeft,
                  child: Card(
                    elevation: cardElavation,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                        bottomLeft: Radius.circular(borderRadius),
                      ),
                    ),
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
                                    style:
                                        Theme.of(context).textTheme.headline3,
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
                                    style:
                                        Theme.of(context).textTheme.headline1,
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
                                      style:
                                          Theme.of(context).textTheme.headline3,
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
                                  style: Theme.of(context).textTheme.headline1,
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
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                                color: iconColor,
                              ),
                              child: Hero(
                                tag: icon.codePoint,
                                child: new Icon(
                                  icon,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            ),
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
