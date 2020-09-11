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
    return SizedBox(
      width: width,
      height: width,
      child: Card(
        elevation: getCardElavation(context),
        color: getTheme().cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: InkWell(
          enableFeedback: true,
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => onPressed(),
          onLongPress: () => onPressed(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10),
                child: Icon(
                  icon,
                  size: 40,
                  color: iconColor,
                ),
              ),
              Container(
                child: Text(
                  text,
                  style: TextStyle(
                    color: getTheme().textColor,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
