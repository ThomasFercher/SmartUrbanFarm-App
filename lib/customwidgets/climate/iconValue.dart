import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/settingsProvider.dart';

class IconValue extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double val;
  final String unit;

  const IconValue({Key key, this.icon, this.color, this.val, this.unit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Container(
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(
            "$val$unit",
            style: TextStyle(
              color: theme.textColor,
              fontWeight: FontWeight.w100,
              fontSize: 28.0,
            ),
          ),
        ],
      ),
    );
  }
}
