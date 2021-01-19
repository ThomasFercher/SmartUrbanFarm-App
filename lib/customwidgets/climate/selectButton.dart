import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/settingsProvider.dart';

import '../../styles.dart';

class SelectButton extends StatelessWidget {
  final MaterialColor color;
  final String title;
  final Function onPressed;
  final IconData icon;
  final bool enabled;
  const SelectButton(
      {Key key,
      this.color,
      this.title,
      this.onPressed,
      this.icon,
      this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return InkWell(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: enabled ? color.shade300 :theme.disabled,
              size: 36,
            ),
            SectionTitle(
                title: title, color: enabled ? color.shade300 : theme.disabled)
          ],
        ),
        decoration: BoxDecoration(
          color: enabled ? color.shade100 :theme.disabled,
          //     border: Border.all(color: Colors.deepOrange.shade200),
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
