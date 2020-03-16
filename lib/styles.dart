library SGS.styles;

import 'dart:ui';

import 'package:flutter/material.dart';

const Color accentColor = Color(0xFFd9f8d7);
const Color primaryColor = Color(0xFF27d91a);
const Color accentColor_d = Color(0xFF2222222);
const Color backgroundColor_d = Color(0xFF000000);
const Color backgroundColor = Color(0xFFFFFFFF);
const double cardElavation = 2.0;
const double borderRadius = 5.0;
const double screen_width = 231;

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
