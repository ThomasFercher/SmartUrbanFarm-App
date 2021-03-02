import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/climate/edit/selectButton.dart';
import 'package:sgs/customwidgets/climate/bottom/verticalListTile.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/dataProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/styles.dart';

class GrowPhaseSelect extends StatelessWidget {
  final String title;
  final MaterialColor color;
  final String phase;
  String left_phase;
  String right_phase;
  final IconData icon;
  final double disabledWidth;
  final double expandedWidth;

  GrowPhaseSelect({
    Key key,
    this.title,
    this.color,
    this.disabledWidth,
    this.expandedWidth,
    this.phase,
    this.left_phase,
    this.right_phase,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Consumer<DataProvider>(builder: (context, data, child) {
      bool isSelected = data.activeClimate.growPhase.phase == phase;

      return GestureDetector(
        onTap: () {
          if (!isSelected) {
            data.activeClimateChangePhase(phase);
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: isSelected
              ? expandedWidth.floor().toDouble()
              : disabledWidth.floor().toDouble(),
          child: Container(
            width: isSelected
                ? expandedWidth.floor().toDouble()
                : disabledWidth.floor().toDouble(),
            child: Chip(
              //  padding: EdgeInsets.all(0),
              labelPadding: EdgeInsets.all(0),
              label: Container(
                height: 42,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    isSelected
                        ? Icon(
                            icon,
                            color: color,
                          )
                        : Container(),
                    Flexible(
                      child: SectionTitle(
                        title: title,
                        color: isSelected ? color : Colors.grey[300],
                        fontSize: isSelected ? 18 : 12,
                      ),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: left_phase == null
                    ? BorderRadius.horizontal(
                        left: Radius.circular(borderRadius))
                    : right_phase == null
                        ? BorderRadius.horizontal(
                            right: Radius.circular(borderRadius))
                        : BorderRadius.horizontal(right: Radius.circular(0)),
              ),
              backgroundColor: isSelected ? color.shade100 : Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
