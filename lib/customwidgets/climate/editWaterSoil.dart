import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/climate/editVariable.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/climateControlProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/styles.dart';

class EditWaterSoil extends StatefulWidget {
  final ClimateControlProvider pr;

  EditWaterSoil({Key key, this.pr}) : super(key: key);

  @override
  _EditWaterSoilState createState() => _EditWaterSoilState();
}

class _EditWaterSoilState extends State<EditWaterSoil> {
  @override
  void initState() {
    super.initState();
  }

  ExpandableThemeData getExpandTheme(AppTheme theme) {
    return ExpandableThemeData(
        headerAlignment: ExpandablePanelHeaderAlignment.center,
        tapBodyToCollapse: false,
        tapHeaderToExpand: false,
        inkWellBorderRadius: BorderRadius.all(Radius.circular(0)),
        useInkWell: false,
        tapBodyToExpand: false,
        expandIcon: Icons.radio_button_off,
        collapseIcon: Icons.radio_button_checked,
        iconColor: theme.textColor);
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return Consumer<ClimateControlProvider>(builder: (context, pr, child) {
      return Container(
        color: theme.background,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            color: theme.cardColor,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: theme.cardColor,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        alignment: Alignment.centerLeft,
                        child: SectionTitle(
                          title: "Irrigation",
                          color: theme.headlineColor,
                          fontSize: 24,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InputChip(
                              onSelected: (value) {
                                pr.changeAutomaticWatering(false);
                              },
                              showCheckmark: false,
                              selectedColor: theme.secondaryColor,
                              avatar: Icon(
                                Icons.tune,
                                color: !pr.climateSettings.automaticWatering
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              backgroundColor: theme.textColor,
                              isEnabled: true,
                              selected: !pr.climateSettings.automaticWatering,
                              label: Container(
                                height: 32,
                                alignment: Alignment.center,
                                child: SectionTitle(
                                    title: "Regulated",
                                    color: !pr.climateSettings.automaticWatering
                                        ? Colors.white
                                        : Colors.black87),
                              ),
                            ),
                            InputChip(
                              showCheckmark: false,
                              onSelected: (value) {
                                pr.changeAutomaticWatering(true);
                              },
                              avatar: Icon(
                                Icons.tune,
                                color: pr.climateSettings.automaticWatering
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              backgroundColor: theme.textColor,
                              selected: pr.climateSettings.automaticWatering,
                              selectedColor: theme.primaryColor,
                              label: Container(
                                height: 32,
                                alignment: Alignment.center,
                                child: SectionTitle(
                                    title: "Automatic",
                                    color: pr.climateSettings.automaticWatering
                                        ? Colors.white
                                        : Colors.black87),
                              ),
                            )
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: Duration(milliseconds: 200),
                        child: pr.climateSettings.automaticWatering
                            ? EditVariable(
                                title: "Automatic",
                                color: theme.primaryColor,
                                value: pr.climateSettings.soilMoisture,
                                isChild: true,
                                icon: WeatherIcons.wi_earthquake,
                                max: 100,
                                min: 0,
                                unit: "%",
                                onValueChanged: (v) => pr.changeSoilMoisture(v),
                              )
                            : EditVariable(
                                title: "Regulated",
                                color: theme.secondaryColor,
                                value: pr.climateSettings.waterConsumption,
                                isChild: true,
                                icon: WeatherIcons.wi_earthquake,
                                max: 100,
                                min: 0,
                                unit: "ml/d",
                                onValueChanged: (v) =>
                                    pr.changeWaterConsumption(v),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      );
    });
  }
}

class SliderVal extends StatelessWidget {
  final double value;
  final String title;
  final Color color;
  final IconData icon;
  final String unit;
  final Function onValueChanged;
  final double min;
  final double max;

  const SliderVal(
      {Key key,
      this.value,
      this.title,
      this.color,
      this.icon,
      this.unit,
      this.onValueChanged,
      this.min,
      this.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(
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
          Container(
            height: 48,
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerRight,
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
    );
  }
}
