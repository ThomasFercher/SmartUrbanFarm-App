import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/climate/editWaterSoil.dart';
import 'package:sgs/customwidgets/climate/growthPhase.dart';
import 'package:sgs/customwidgets/general/appBarHeader.dart';
import 'package:sgs/customwidgets/climate/dayslider.dart';
import 'package:sgs/customwidgets/climate/editVariable.dart';
import 'package:sgs/customwidgets/climate/input.dart';
import 'package:sgs/objects/climateControl.dart';
import 'package:sgs/objects/vpd.dart';
import 'package:sgs/providers/dataProvider.dart';
import 'package:sgs/providers/climateControlProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';

import '../styles.dart';
import 'package:sgs/objects/appTheme.dart';

class EditEnvironment extends StatefulWidget {
  ClimateControl initialSettings;
  bool create;

  EditEnvironment({@required this.initialSettings, @required this.create});

  @override
  _EditEnvironmentState createState() => _EditEnvironmentState();
}

class _EditEnvironmentState extends State<EditEnvironment> {
  @override
  void initState() {
    super.initState();
  }

  save(ClimateControl settings, context) {
    print(settings);
    widget.create
        ? Provider.of<DataProvider>(context, listen: false)
            .createClimate(settings)
        : Provider.of<DataProvider>(context, listen: false)
            .editClimate(this.widget.initialSettings, settings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var name = widget.initialSettings.name;

    return ListenableProvider(
      create: (_) => ClimateControlProvider(widget.initialSettings),
      builder: (context, child) {
        AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
        //   EnvironmentSettings settings = d.getSettings();
        return Consumer<ClimateControlProvider>(builder: (context, pr, child) {
          return AppBarHeader(
            title: widget.create ? "Create Climate" : "Edit $name",
            isPage: true,
            contentPadding: false,
            bottomBarColor: theme.cardColor,
            bottomAction: Container(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset:
                          Offset(0.0, -2.0), // shadow direction: bottom right
                    )
                  ],
                ),
                child: RaisedButton(
                  onPressed: () => save(pr.getSettings(), context),
                  color: theme.primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    widget.create ? "Create" : "Save",
                    style: GoogleFonts.nunito(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
            body: [
              Input(
                theme: theme,
                initialValue: pr.climateSettings.name,
                valChanged: (val) => pr.changeName(val),
              ),
              GrowthPase(),
              EditWaterSoil(
                pr: pr,
              ),
              Container(
                height: 80,
              )
            ],
          );
        });
      },
    );
  }
}

class PlaceDivider extends StatelessWidget {
  double height;

  PlaceDivider({height}) : height = height ?? 8.0;

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Container(
      color: Colors.green[50],
      height: height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
