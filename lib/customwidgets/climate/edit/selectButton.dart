import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../../objects/appTheme.dart';
import '../../../providers/settingsProvider.dart';
import '../../../styles.dart';
import '../../general/sectionTitle.dart';

class SelectButton extends StatelessWidget {
  final MaterialColor color;
  final String title;
  final Function onPressed;
  final IconData icon;
  final bool enabled;
  final BorderRadiusGeometry borderRadiusGeo;
  const SelectButton({
    Key key,
    this.color,
    this.title,
    this.onPressed,
    this.icon,
    this.enabled,
    this.borderRadiusGeo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: enabled ? color.shade200 : theme.disabled,
              size: 36,
            ),
            SectionTitle(
              title: title,
              color: enabled ? color.shade200 : theme.disabled,
              fontSize: 14,
            )
          ],
        ),
        decoration: BoxDecoration(
          color: enabled ? color : theme.disabled,
          //     border: Border.all(color: Colors.deepOrange.shade200),
          borderRadius: borderRadiusGeo ??
              BorderRadius.all(
                Radius.circular(borderRadius),
              ),
        ),
      ),
    );
  }
}
