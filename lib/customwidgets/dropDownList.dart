import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sgs/styles.dart';

class DropDownList extends StatelessWidget {
  final Icon icon;
  final List<String> options;

  DropDownList({Key key, this.icon, this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return IconButton(
      icon: icon,
      onPressed: () {
        showGeneralDialog(
          barrierLabel: "Barrier",
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 700),
          context: context,
          pageBuilder: (_, __, ___) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 300,
                width: 100,
                margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            );
          },
          transitionBuilder: (_, anim, __, child) {
            return SlideTransition(
              position:
                  Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
              child: child,
            );
          },
        );
      },
    );
  }
}
