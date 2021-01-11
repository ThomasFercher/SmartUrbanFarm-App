import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/settingsProvider.dart';

import '../../styles.dart';

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
      color: theme.background,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: theme.cardColor,
        child: Container(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, bottom: 10, top: 5),
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
      ),
    );
  }
}
