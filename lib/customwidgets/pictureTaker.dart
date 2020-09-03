import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/customwidgets/detaildialog.dart';
import 'package:sgs/customwidgets/smalldatachart.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';

class PictureTaker extends StatelessWidget {
  Function onPressed;

  PictureTaker({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () => onPressed(),
        child: Card(
          elevation: cardElavation + 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.camera_alt,
                  color: primaryColor,
                ),
              ),
              Container(
                child: Text(
                  "Take a picture",
                  style: Theme.of(context).textTheme.headline3,
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
