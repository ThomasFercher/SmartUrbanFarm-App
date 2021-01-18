import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';

import '../../styles.dart';

class SelectButton extends StatelessWidget {
  final MaterialColor color;
  final String title;
  final Function onPressed;
  final IconData icon;

  const SelectButton(
      {Key key, this.color, this.title, this.onPressed, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color.shade300,
              size: 36,
            ),
            SectionTitle(title: title, color: color.shade300)
          ],
        ),
        decoration: BoxDecoration(
          color: color.shade100,
          //     border: Border.all(color: Colors.deepOrange.shade200),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
