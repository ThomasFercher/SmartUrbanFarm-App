import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../providers/settingsProvider.dart';

class IconValue extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String val;
  final String unit;
  final double fontsize;

  const IconValue(
      {Key key, this.icon, this.color, this.val, this.unit, this.fontsize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Text(
            "$val$unit",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w100,
              fontSize: fontsize ?? 20,
            ),
          ),
        ],
      ),
    );
  }
}
