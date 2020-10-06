import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/customwidgets/dayslider.dart';
import 'package:sgs/customwidgets/sectionTitle.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/providers/environmentSettingsProvider.dart';
import 'package:weather_icons/weather_icons.dart';
import '../styles.dart';

class EditEnvironment extends StatelessWidget {
  EnvironmentSettings initialSettings;

  EditEnvironment({@required this.initialSettings});

  save(EnvironmentSettings settings, context) {
    print(settings);
    Provider.of<DashboardProvider>(context, listen: false)
        .editSettings(this.initialSettings, settings);
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
            title: "Edit $name",
            isPage: true,
            theme: theme,
            contentPadding: false,
            bottomAction: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              color: Colors.white,
              child: RaisedButton(
                onPressed: () => save(pr.getSettings(), context),
                color: theme.primaryColor,
                textColor: Colors.white,
                child: Text(
                  "Save",
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
              PlaceDivider(
                height: 100.0,
              )
            ],
          );
        });
      },
    );
  }
}

class Input extends StatelessWidget {
  const Input({
    Key key,
    @required this.theme,
    @required this.initialValue,
    @required this.valChanged,
  }) : super(key: key);

  final AppTheme theme;
  final String initialValue;
  final Function valChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: SectionTitle(
              title: "Name",
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 48,
            child: TextFormField(
              cursorColor: theme.primaryColor,
              initialValue: initialValue,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.primaryColor),
                  borderRadius: BorderRadius.circular(5.0),
                ),

                //fillColor: Colors.green
              ),
              onChanged: (value) => valChanged(value),
              validator: (val) {
                if (val.length == 0) {
                  return "Name cannot be empty!";
                } else {
                  return null;
                }
              },
              style: GoogleFonts.nunito(
                color: Colors.black87,
                fontSize: 20,
                height: 1,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
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
    print(((max - min) * 2).round());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      color: Colors.white,
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
    );
  }
}

class PlaceDivider extends StatelessWidget {
  double height;

  PlaceDivider({height}) : height = height ?? 15.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      height: height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
