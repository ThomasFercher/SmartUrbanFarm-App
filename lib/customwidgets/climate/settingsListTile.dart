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
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: theme.textColor,
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: subtitle ?? null,
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.textColor.withOpacity(0.03)),
        child: Icon(
          icon,
          color: color,
          size: 18,
        ),
      ),
      trailing: Container(
        height: 48,
        padding: EdgeInsets.only(top: 10),
        child: Text(
          "$val$unit",
          style: TextStyle(
            color: theme.textColor,
            fontWeight: FontWeight.w100,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}
