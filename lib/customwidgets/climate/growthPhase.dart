import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/climate/dayslider.dart';
import 'package:sgs/customwidgets/climate/editVariable.dart';
import 'package:sgs/customwidgets/climate/growthItem.dart';
import 'package:sgs/customwidgets/climate/selectButton.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/objects/growPhase.dart';
import 'package:sgs/objects/vpd.dart';
import 'package:sgs/providers/climateControlProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/styles.dart';

class GrowthPase extends StatefulWidget {
  @override
  _GrowthPaseState createState() => _GrowthPaseState();
}

class _GrowthPaseState extends State<GrowthPase> {
  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Consumer<ClimateControlProvider>(builder: (context, pr, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 550,
        child: Card(
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(borderRadius),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(borderRadius),
                alignment: Alignment.centerLeft,
                child: SectionTitle(
                  title: "Grow Phases",
                  color: theme.headlineColor,
                  fontSize: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.all(borderRadius),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(borderRadius),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectButton(
                        color: Colors.deepPurple,
                        title: "Vegetation",
                        icon: MaterialCommunityIcons.sprout,
                        onPressed: () {
                          pr.changePhase(GROWPHASEVEGETATION);
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: SelectButton(
                        color: Colors.green,
                        icon: FontAwesome.pagelines,
                        title: "Early Flower",
                        onPressed: () {
                          pr.changePhase(GROWPHASEFLOWER);
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Expanded(
                      child: SelectButton(
                        color: Colors.amber,
                        icon: FontAwesome.pagelines,
                        title: "Late Flower",
                        onPressed: () {
                          pr.changePhase(GROWPHASELATEFLOWER);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey[300],
              ),
              Expanded(
                child: Container(
                  height: 4000,
                  //      color: Colors.red,
                  child: GrowthItem(
                    phase: pr.sel_phase,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
