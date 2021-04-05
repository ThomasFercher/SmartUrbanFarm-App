import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';

import '../../objects/appTheme.dart';
import '../../providers/dataProvider.dart';
import '../../providers/settingsProvider.dart';
import '../../styles.dart';

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
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return Container(
      child: Consumer<DataProvider>(
        builder: (context, d, child) {
          return Card(
            elevation: cardElavation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            color: theme.cardColor, //icon
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
                      color: theme.textColor,
                      fontWeight: FontWeight.w200,
                      fontSize: 26.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
