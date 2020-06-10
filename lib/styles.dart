library sgs.styles;

import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color accentColor = Color(0xFFe2e2e2);
const Color primaryColor = Color(0xFF1db954);
const Color backgroundColor_d = Color(0xFF000000);
const Color accentColor_d = Color(0xFF212121);
const Color backgroundColor = Color(0xFFFFFFFF);
const double cardElavation = 2.0;
const double borderRadius = 5.0;
const double screen_width = 231;
const Color text_gray = Color(0xFF646464);
const Color dark_gray = Color(0xFFb4b4b4);
Image logo = new Image(image: null);
final fb = FirebaseDatabase.instance;

double temperature;
double humidity;
SplayTreeMap<DateTime, double> temperatures;
SplayTreeMap<DateTime, double> humiditys;

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
