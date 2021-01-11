import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/settingsProvider.dart';

import '../../styles.dart';

class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final double value;
  final String value_text;
  final Color color;
  final String unit;
  final Text subtitle;

  const SettingsListTile({
    Key key,
    this.color,
    this.icon,
    this.title,
    this.value,
    this.value_text,
    this.unit,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var val = value ?? value_text;
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return LayoutBuilder(builder: (context, constraints) {
      var height = constraints.maxHeight;

      return Container(
        child: ListTile(
          title: Container(
            height: height,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                color: theme.textColor,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          subtitle: subtitle ?? null,
          leading: Container(
            height: height - 8,
            width: height - 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                (height - 8) / 3.2,
              ),
              color: theme.textColor.withOpacity(0.03),
            ),
            child: Icon(
              icon,
              color: color,
              size: height / 3,
            ),
          ),
          trailing: Container(
            child: Text(
              "$val$unit",
              style: TextStyle(
                color: theme.textColor,
                fontWeight: FontWeight.w100,
                fontSize: 26.0,
              ),
            ),
          ),
        ),
      );
    });
  }
}
