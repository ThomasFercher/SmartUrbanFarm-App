import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/customwidgets/detaildialog.dart';
import 'package:sgs/customwidgets/smalldatachart.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';

class ActionCard extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String text;
  final Color iconColor;
  final double width;

  ActionCard({
    @required this.onPressed,
    @required this.icon,
    @required this.iconColor,
    @required this.text,
    @required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: cardElavation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      color: iconColor,
      child: Container(
        width: width,
        height: width,
        child: InkWell(
          enableFeedback: true,
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => onPressed(),
          onLongPress: () => onPressed(),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white, //Colors.white.withOpacity(1),
            ),
          ),
        ),
      ),
    );
  }
}
