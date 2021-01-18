import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';

import '../../styles.dart';

class SelectButton extends StatelessWidget {
  final MaterialColor color;
  final String title;
  final Function onPressed;
  final IconData icon;
  final bool enabled;
  const SelectButton(
      {Key key,
      this.color,
      this.title,
      this.onPressed,
      this.icon,
      this.enabled})
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
              color: enabled ? color.shade300 : Colors.black12,
              size: 36,
            ),
            SectionTitle(
                title: title, color: enabled ? color.shade300 : Colors.black12)
          ],
        ),
        decoration: BoxDecoration(
          color: enabled ? color.shade100 : Colors.black12,
          //     border: Border.all(color: Colors.deepOrange.shade200),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
