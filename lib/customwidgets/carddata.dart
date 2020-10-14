import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/customwidgets/detaildialog.dart';
import 'package:sgs/customwidgets/slider.dart';
import 'package:sgs/customwidgets/smalldatachart.dart';
import 'package:sgs/pages/advanced.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';

class CardData extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;
  final Color iconColor;
  final String type;
  final GlobalKey key;

  /// This widget displays a given text with a label and icon
  /// All this is displayed in a card
  CardData({
    @required this.icon,
    @required this.text,
    @required this.label,
    @required this.iconColor,
    @required this.type,
    @required this.key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, d, child) {
        
        return CupertinoContextMenu(
          actions: [
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Material(
                   
                    child: Container(
                      width: 200,
                      color: Colors.white,
                      padding: EdgeInsets.only(top: 15, left: 15),
                      child: Text(
                        "Change Sollwert",
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: MenuSlider(
                      width: 220,
                      color: iconColor,
                      type: type,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              child: Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    "Show Advanced Data",
                    softWrap: false,
                  ),
                  trailing: Icon(
                    Icons.assessment,
                    color: iconColor,
                    size: 20,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Advanced(),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
          previewBuilder: (context, animation, child) {
            var curvedValue = Curves.easeOut.transform(animation.value);
            return Opacity(
              opacity: curvedValue,
              child: detailedPopup(context, d),
            );
          },
          child: Card(
            elevation: cardElavation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),

                color: Colors.white, //iconColor, //getTheme().cardColor,
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.tight,
                    child: Icon(
                      icon,
                      size: 26,
                      color: iconColor,
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      text,
                      style: GoogleFonts.nunito(
                        color: Colors.black54,
                        fontWeight: FontWeight.w200,
                        fontSize: 26.0,

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getSmallDataChart(var name, DashboardProvider d, AppTheme theme) {
    switch (name) {
      case "Temperatur":
        return SmallDataChart(
          data: d.getTemperatures(),
          gradientColors: [theme.primaryColor, theme.primaryColor],
        );
        break;
      case "Luftfeuchtigkeit":
        return SmallDataChart(
          data: d.getHumiditys(),
          gradientColors: [theme.primaryColor, theme.primaryColor],
        );
        break;
      default:
        return Container();
    }
  }

  getValueString(type, DashboardProvider d) {
    switch (type) {
      case Temperature:
        return d.tempSoll.toString() + "°C";
        break;
      case Humidity:
        return d.humiditySoll.toString() + "%";
        break;
      case SoilMoisture:
        return d.soilMoistureSoll.toString() + "%";
        break;
      default:
        return 0.0;
    }
  }

  List<double> getMargin(type, width) {
    switch (type) {
      case Temperature:
        return [0, width - 280 - 40];
        break;
      case Humidity:
        return [(width - 280 - 40) / 2, (width - 280 - 40) / 2];
        break;
      case SoilMoisture:
        return [width - 280 - 40, 0];
        break;
    }
  }

  Widget detailedPopup(BuildContext context, DashboardProvider d) {
    AppTheme theme = getTheme();
    return Consumer<DashboardProvider>(
      builder: (context, d, child) {
        return Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.only(
              top: 8,
              left: getMargin(type, MediaQuery.of(context).size.width)[0],
              right: getMargin(type, MediaQuery.of(context).size.width)[1],
            ),
            width: 280,
            height: 350.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              color: theme.cardColor,
            ),
            child: LayoutBuilder(builder: (context, contraints) {
              double height = contraints.maxHeight;
              double rowheight = 35;
              double avheight = height > 2 * rowheight + 47 ? height - 117 : 0;
              rowheight = avheight < rowheight ? 0 : 35;
              return Column(
                children: [
                  /*   Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 60,
                      height: 60,
                      //   transform: Matrix4.translationValues(0, -25, 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(borderRadius),
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
                  ),*/
                  Padding(padding: EdgeInsets.only(top: borderRadius)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          height: rowheight,
                          width: 140,
                          padding: EdgeInsets.only(bottom: 4, left: 10),
                          child: Hero(
                            tag: label,
                            child: new Text(
                              label,
                              style: GoogleFonts.nunito(
                                color: getTheme().textColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          height: rowheight,
                          width: 110,
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 10),
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
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          height: rowheight,
                          width: 140,
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(bottom: 4, left: 10),
                          margin: EdgeInsets.only(top: 15),
                          child: new Text(
                            "Sollwert",
                            style: GoogleFonts.nunito(
                              color: getTheme().textColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          height: rowheight,
                          width: 110,
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(right: 10),
                          margin: EdgeInsets.only(top: 15),
                          child: new Text(
                            getValueString(type, d),
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
                  Divider(
                    color: Colors.black12,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    height: avheight,
                    child: getSmallDataChart(
                      label,
                      d,
                      theme
                    ),
                  ),
                ],
              );
            }),
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
