import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/settingsProvider.dart';

import '../../styles.dart';
import '../sectionTitle.dart';

class EditVariable extends StatelessWidget {
  final double value;
  final String title;
  final Color color;
  final IconData icon;
  final String unit;
  final Function onValueChanged;
  final double min;
  final double max;

  EditVariable({
    this.value,
    this.title,
    this.color,
    this.icon,
    this.unit,
    this.onValueChanged,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    print(((max - min) * 2).round());
    return Container(
      color: Colors.grey[50],
      child: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
        color: theme.background,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  child: SectionTitle(
                    title: title,
                    fontSize: 20,
                    color: theme.headlineColor,
                  ),
                ),
                Container(
                  height: 48,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "$value$unit",
                    style: TextStyle(
                      color: theme.headlineColor,
                      fontWeight: FontWeight.w100,
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: CupertinoSlider(
                value: value,
                onChanged: (val) {
                  val = double.parse((val).toStringAsFixed(2));
                  onValueChanged(val);
                },
                activeColor: color,
                max: max,
                min: min,
                divisions: ((max - min) * 2).round(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
