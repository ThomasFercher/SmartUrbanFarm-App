library sgs.styles;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

const Color accentColor = Color(0xFFe2e2e2);
const Color primaryColor = Color(0xFF1db954);
const Color backgroundColor_d = Color(0xFF000000);
const Color accentColor_d = Color(0xFF212121);
const Color backgroundColor = Color(0xFFFFFFFF);
const double cardElavation = 2.0;
const double borderRadius = 5.0;
const double screen_width = 231;
const Color text_gray = Color(0xFF757575);
final fb = FirebaseDatabase.instance;

var temperature = 0.0;
var humidity = 0.0;
List<double> temperatures = [0.0];
List<double> humiditys = [0.0];

List<Color> temperatureGradient = [
  primaryColor,
  const Color(0xff02d39a),
];

List<Color> humidityGradient = [
  Colors.purple,
  Colors.deepPurple
];

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
