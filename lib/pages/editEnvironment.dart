import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/customwidgets/sectionTitle.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:weather_icons/weather_icons.dart';
import '../styles.dart';

class EditEnvironment extends StatelessWidget {
  EnvironmentSettings settings;

  EditEnvironment({@required this.settings});

  saveSettings() {
    print("safe");
  }

  @override
  Widget build(BuildContext context) {
    var name = settings.name;
    return Consumer<DashboardProvider>(builder: (context, d, child) {
      AppTheme theme = getTheme();
      return AppBarHeader(
        title: "Edit $name",
        isPage: true,
        theme: theme,
        body: [
          Padding(padding: EdgeInsets.only(top: 15)),
          CupertinoTextField(
            cursorColor: theme.primaryColor,
            style: GoogleFonts.nunito(fontSize: 18),
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          EditVariable(
            value: settings.temperature,
            color: Colors.redAccent,
            title: "Temperature",
            unit: "°C",
            icon: WeatherIcons.thermometer,
            min: 0,
            max: 50,
            onValueChanged: (v) {
              print(v);
            },
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          EditVariable(
            value: settings.temperature,
            color: Colors.blueAccent,
            title: "Humidty",
            unit: "%",
            icon: WeatherIcons.humidity,
            min: 0,
            max: 100,
            onValueChanged: (v) {
              print(v);
            },
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          EditVariable(
            value: settings.temperature,
            color: Colors.brown,
            title: "Soil Moisture",
            unit: "%",
            icon: WeatherIcons.barometer,
            min: 0,
            max: 100,
            onValueChanged: (v) {
              print(v);
            },
          ),
          Padding(padding: EdgeInsets.only(top: 15)),
          EditVariable(
            value: settings.temperature,
            color: Colors.lightBlueAccent,
            title: "Water Consumption",
            unit: "l/d",
            icon: WeatherIcons.barometer,
            min: 0,
            max: 100,
            onValueChanged: (v) {
              print(v);
            },
          ),
          Padding(padding: EdgeInsets.only(top: 250)),
          CupertinoButton(
            onPressed: () => saveSettings(),
            color: theme.primaryColor,
            child: Text("Save"),
            borderRadius: BorderRadius.circular(borderRadius),
          )
        ],
      );
    });
  }
}

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
    AppTheme theme = getTheme();
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 48,
                child: SectionTitle(
                  title: title,
                  fontSize: 24,
                ),
              ),
              Container(
                height: 48,
                alignment: Alignment.bottomRight,
                child: Text(
                  "$value$unit",
                  style: TextStyle(
                    color: getTheme().textColor,
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
              onChanged: (val) => onValueChanged(val),
              activeColor: color,
              max: max,
              min: min,
            ),
          ),
        ],
      ),
    );
  }
}
