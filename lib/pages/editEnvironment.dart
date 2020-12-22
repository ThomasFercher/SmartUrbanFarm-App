import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/dayslider.dart';
import 'package:sgs/customwidgets/environment/editVariable.dart';
import 'package:sgs/customwidgets/environment/input.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/providers/environmentSettingsProvider.dart';
import 'package:weather_icons/weather_icons.dart';
import '../styles.dart';
import 'package:sgs/objects/appTheme.dart';

class EditEnvironment extends StatelessWidget {
  EnvironmentSettings initialSettings;
  bool create;

  EditEnvironment({@required this.initialSettings, @required this.create});

  save(EnvironmentSettings settings, context) {
    print(settings);
    create
        ? Provider.of<DashboardProvider>(context, listen: false)
            .createEnvironment(settings)
        : Provider.of<DashboardProvider>(context, listen: false)
            .editEnvironment(this.initialSettings, settings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var name = initialSettings.name;
    return ListenableProvider(
      create: (_) => EnvironmentSettingsProvider(initialSettings),
      builder: (context, child) {
        AppTheme theme = getTheme();
        //   EnvironmentSettings settings = d.getSettings();
        return Consumer<EnvironmentSettingsProvider>(
            builder: (context, pr, child) {
          return AppBarHeader(
            title: create ? "Create Environment" : "Edit $name",
            isPage: true,
            theme: theme,
            contentPadding: false,
            bottomAction: Container(
                 color: getTheme().cardColor,
                          child: Container(
                
                width: MediaQuery.of(context).size.width,
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: getTheme().background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(0.0, -2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: RaisedButton(
                  onPressed: () => save(pr.getSettings(), context),
                  color: theme.primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    create ? "Create" : "Save",
                    style: GoogleFonts.nunito(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
            body: [
              Input(
                theme: theme,
                initialValue: pr.settings.name,
                valChanged: (val) => pr.changeName(val),
              ),
              PlaceDivider(),
              EditVariable(
                value: pr.settings.temperature,
                color: Colors.redAccent,
                title: "Temperature",
                unit: "°C",
                icon: WeatherIcons.thermometer,
                min: 0,
                max: 50,
                onValueChanged: (v) {
                  pr.changeTemperature(v);
                },
              ),
              PlaceDivider(),
              EditVariable(
                value: pr.settings.humidity,
                color: Colors.blueAccent,
                title: "Humidty",
                unit: "%",
                icon: WeatherIcons.humidity,
                min: 0,
                max: 100,
                onValueChanged: (v) {
                  pr.changeHumidity(v);
                },
              ),
              PlaceDivider(),
              EditVariable(
                value: pr.settings.soilMoisture,
                color: Colors.brown,
                title: "Soil Moisture",
                unit: "%",
                icon: WeatherIcons.barometer,
                min: 0,
                max: 100,
                onValueChanged: (v) {
                  pr.changeSoilMoisture(v);
                },
              ),
              PlaceDivider(),
              EditVariable(
                value: pr.settings.waterConsumption,
                color: Colors.lightBlueAccent,
                title: "Water Consumption",
                unit: "l/d",
                icon: WeatherIcons.barometer,
                min: 0,
                max: 100,
                onValueChanged: (v) {
                  pr.changeWaterConsumption(v);
                },
              ),
              PlaceDivider(),
              DaySlider(
                onValueChanged: (v) => pr.changeSuntime(v),
                initialTimeString: pr.settings.suntime,
              ),
              PlaceDivider()
            ],
          );
        });
      },
    );
  }
}

class PlaceDivider extends StatelessWidget {
  double height;

  PlaceDivider({height}) : height = height ?? 15.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getTheme().cardColor,
      height: height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
