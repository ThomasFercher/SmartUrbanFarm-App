library sgs.styles;

import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;

const Color accentColor = Colors.white; //Color(0xFFe2e2e2);
const Color primaryColor = Color(0xFF1db954);
const Color backgroundColor_d = Color(0xFF000000);
const Color accentColor_d = Color(0xFF212121);
const Color backgroundColor = Color(0xFFFFFFFF);
const double cardElavation = 1.0;
const double borderRadius = 8.0;
const double screen_width = 231;
const Color text_gray = Color(0xFF646464);
const Color dark_gray = Color(0xFFb4b4b4);
Image logo = new Image(image: null);
final fb = FirebaseDatabase.instance;

List<Color> temperatureGradient = [
  primaryColor,
  const Color(0xff02d39a),
];

TextStyle sectionTitleStyle(context, Color color) => GoogleFonts.lato(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );

TextStyle normal(context) => GoogleFonts.lato(
      textStyle: TextStyle(
        color: isDark(context) ? dark_gray : dark_gray,
        //fontWeight: FontWeight.w600,
      ),
    );

Widget sectionTitle(BuildContext context, String title, Color color) {
  return Container(
    padding: EdgeInsets.only(left: 4, bottom: 15),
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: sectionTitleStyle(context, color),
    ),
  );
}

List<Color> humidityGradient = [Colors.purple, Colors.deepPurple];
bool isDark(context) {
  return MediaQuery.of(context).platformBrightness == Brightness.light
      ? false
      : true;
}

double getWidth(context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(context) {
  return MediaQuery.of(context).size.width;
}

double getCardElavation(context) {
  return isDark(context) ? 0 : cardElavation;
}

SplayTreeMap<DateTime, double> sortData(Map<dynamic, dynamic> data) {
  Map<DateTime, double> d = data.map((key, value) => MapEntry(
      DateTime.parse(key),
      value.runtimeType == double ? value : double.parse(value)));
  SplayTreeMap<DateTime, double> sorted =
      new SplayTreeMap<DateTime, double>.from(d, (a, b) => a.compareTo(b));
  return sorted;
}

ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.green,
  primaryColor: primaryColor,
  accentColor: accentColor,
  primaryTextTheme: Typography.material2018(platform: TargetPlatform.iOS).white,
  textTheme: TextTheme(
    subtitle2: TextStyle(
      color: Colors.white,
    ),
    headline2: TextStyle(
      color: text_gray,
      fontSize: 13.0,
      fontWeight: FontWeight.w400,
    ),
    headline3: TextStyle(
      color: text_gray,
      fontSize: 15.0,
      fontWeight: FontWeight.w600,
    ),
    headline6: TextStyle(
      color: accentColor,
      fontSize: 24,
      fontFamily: "Lato",
    ),
    headline1: TextStyle(
      color: Colors.black87,
      fontSize: 30.0,
    ),
  ),
);

ThemeData darkThemData = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.green,
  accentColor: accentColor_d,
  primaryColor: backgroundColor_d,
  canvasColor: backgroundColor_d,
  textTheme: TextTheme(
    headline5: TextStyle(color: accentColor),
    headline6: TextStyle(
      color: accentColor,
      fontFamily: "lato",
      fontSize: 24,
    ),
    subtitle1: TextStyle(color: accentColor),
    subtitle2: TextStyle(color: Colors.white),
    headline2: TextStyle(
      color: text_gray,
      fontSize: 13.0,
      fontWeight: FontWeight.w400,
    ),
    headline1: TextStyle(
      color: dark_gray,
      fontSize: 30.0,
    ),
  ),
);

EdgeInsets lerp(EdgeInsets a, EdgeInsets b, double t) {
  assert(t != null);
  if (a == null && b == null) return null;
  if (a == null) return b * t;
  if (b == null) return a * (1.0 - t);
  return EdgeInsets.fromLTRB(
    ui.lerpDouble(a.left, b.left, t),
    ui.lerpDouble(a.top, b.top, t),
    ui.lerpDouble(a.right, b.right, t),
    ui.lerpDouble(a.bottom, b.bottom, t),
  );
}
