import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/customwidgets/datachart.dart';
import 'package:sgs/objects/environmentSettings.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import '../styles.dart';

class EditEnvironment extends StatelessWidget {
  EnvironmentSettings settings;

  EditEnvironment({@required this.settings});

  @override
  Widget build(BuildContext context) {
    var name = settings.name;
    return AppBarHeader(
      title: "Edit $name",
      isPage: true,
      theme: getTheme(),
      body: [Consumer<DashboardProvider>(
        builder: (context, d, child) {
          return Container();
        },
      ),]
    );
  }
}
