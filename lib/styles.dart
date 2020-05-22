library SGS.styles;

import 'dart:ui' as UI;

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


UI.Image dusk_icon = null;
UI.Image dusk_icon2 = null;
UI.Image dawn_icon = null;
UI.Image midday_icon = null;
UI.Image night_icon = null;
var temperature = "0.0";
var humidity = "0.0";

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
