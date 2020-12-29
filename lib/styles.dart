library sgs.styles;

import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;
import 'package:sgs/objects/appTheme.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

//
const Color backgroundColor = Color(0xFFFCFCFC);

const Color accentColor = Colors.white; //Color(0xFFe2e2e2);
const Color primaryColor = Color(0xFF26C281);
const Color backgroundColor_d = Color(0xff065446);
const Color accentColor_d = Color(0xFF323232);

const double cardElavation = 0.5;
const double borderRadius = 16.0;
const double screen_width = 231;
const Color text_gray = Color(0xFF646464);
const Color dark_gray = Color(0xFFb4b4b4);
const Color d_text_gray = Color(0xFFedeae4);
Image logo = new Image(image: null);
final fb = FirebaseDatabase.instance;
const Color gray = Color(0xFF1f1f1f);

const String Temperature = 'Temperature';
const String Humidity = 'Humidity';
const String SoilMoisture = 'SoilMoisture';

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
  /*Color(0xFFb2dfdb)*/ Color(0xFF26C281), Colors.white
  //const Color(0xFF1d976c),
  //Colors.white,
];

List<Color> temperatureGradient = [
  primaryColor,
  const Color(0xff02d39a),
];

TextStyle sectionTitleStyle(context, Color color) => GoogleFonts.nunito(
      textStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
    );

TextStyle normal(context) => GoogleFonts.lato(
      textStyle: TextStyle(
        color: isDark(context) ? dark_gray : dark_gray,
        //fontWeight: FontWeight.w600,
      ),
    );

TextStyle buttonTextStyle = GoogleFonts.nunito(
    fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white);

Widget sectionTitle(BuildContext context, String title, Color color) {
  return Container(
    padding: EdgeInsets.only(left: 4, bottom: 8),
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      textAlign: TextAlign.start,
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
  return cardElavation;
}

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
