library sgs.styles;

import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;

const Color accentColor = Colors.white; //Color(0xFFe2e2e2);
const Color primaryColor = Color(0xFF1db954);
const Color backgroundColor_d = Color(0xff065446);
const Color accentColor_d = Color(0xFF323232);
const Color backgroundColor = Color(0xFFFFFFFF);
const double cardElavation = 2.0;
const double borderRadius = 8.0;
const double screen_width = 231;
const Color text_gray = Color(0xFF646464);
const Color dark_gray = Color(0xFFb4b4b4);
const Color d_text_gray = Color(0xFFedeae4);
Image logo = new Image(image: null);
final fb = FirebaseDatabase.instance;
const Color gray = Color(0xFF1f1f1f);

Color topColor = gradient4[0]; //Color(0xFF007243);
Color bottomColor = gradient4[1]; //Color(0xFF396f5f);
const Color background_t = Color(0x48000000);

List<Color> gradient1 = [
  const Color(0xFF4ac29a),
  const Color(0xFFbdfff3),
];

List<Color> gradient2 = [
  Colors.teal[800],
  Colors.green[300],
];

List<Color> gradient3 = [
  Colors.blueAccent,
  const Color(0xFF000000),
];

List<Color> gradient4 = [
  const Color(0xFF1d976c),
  Colors.white,
];

List<Color> temperatureGradient = [
  primaryColor,
  const Color(0xff02d39a),
];

var selectedTheme = 0;

AppTheme getTheme() {
  return themes[selectedTheme];
}

List<AppTheme> themes = [
  new AppTheme(
    name: "light",
    cardColor: Colors.white,
    background: gradient4,
    textColor: Colors.black87,
    headlineColor: Colors.white,
  ),
  new AppTheme(
    name: "cool",
    cardColor: background_t,
    background: gradient2,
    textColor: Colors.white,
    headlineColor: Colors.white,
  ),
  new AppTheme(
    name: "dark",
    cardColor: accentColor_d,
    background: gradient3,
    textColor: Colors.white,
    headlineColor: Colors.white,
  )
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
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
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
  return cardElavation;
}

SplayTreeMap<DateTime, double> sortData(Map<dynamic, dynamic> data) {
  Map<DateTime, double> d = data.map((key, value) => MapEntry(
      DateTime.parse(key),
      value.runtimeType == double ? value : double.parse(value)));
  SplayTreeMap<DateTime, double> sorted =
      new SplayTreeMap<DateTime, double>.from(d, (a, b) => a.compareTo(b));
  return sorted;
}

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.green,
  primaryColor: primaryColor,
  accentColor: accentColor,
  textTheme: TextTheme(
    subtitle2: TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w400,
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

class AppTheme {
  final String name;
  final Color cardColor;
  final List<Color> background;
  final Color textColor;
  final Color headlineColor;

  AppTheme(
      {this.cardColor,
      this.background,
      this.textColor,
      this.headlineColor,
      this.name});
}
