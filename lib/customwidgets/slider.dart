import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import 'package:sgs/styles.dart';

class MenuSlider extends StatelessWidget {
  final String type;
  final Color color;
  final double width;

  const MenuSlider({
    Key key,
    this.type,
    this.color,
    this.width,
  }) : super(key: key);

  getValue(type, DashboardProvider d) {
    switch (type) {
      case Temperature:
        return d.tempSoll;
        break;
      case Humidity:
        return d.humiditySoll;
        break;
      case SoilMoisture:
        return d.soilMoistureSoll;
        break;
    }
  }

  onValueChanged(val, type, DashboardProvider d) {
    switch (type) {
      case Temperature:
        return d.tempSollChanged(val);
        break;
      case Humidity:
        return d.humiditySollChanged(val);
        break;
      case SoilMoisture:
        return d.soilMoistureSollChanged(val);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, d, child) {
        print(getValue(type, d));
        return Container(
          width: width,
          child: CupertinoSlider(
            activeColor: color,
            divisions: 100,
            value: getValue(type, d),
            onChanged: (value) => onValueChanged(value, type, d),
            min: 0,
            max: 50,
          ),
        );
      },
    );
  }
}
