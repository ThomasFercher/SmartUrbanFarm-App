import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/dataProvider.dart';
import '../../../styles.dart';
import '../../general/sectionTitle.dart';

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
