import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/objects/popupMenuOption.dart';
import 'package:sgs/providers/settingsProvider.dart';

import '../styles.dart';

class PopupMenu extends StatelessWidget {
  final List<PopupMenuOption> options;
  final Function onSelected;
  final Color color;

  const PopupMenu({Key key, this.options, this.onSelected, this.color})
      : super(key: key);

  PopupMenuItem<String> getDropDownMenuItem(
      String option, Icon icon, context, AppTheme theme) {
    return PopupMenuItem<String>(
      value: option,
      child: Row(
        children: [
          icon == null
              ? Container()
              : Padding(
                  child: icon,
                  padding: EdgeInsets.only(right: 8),
                ),
          Expanded(
            child: Text(
              option,
              style: GoogleFonts.nunito(color: theme.textColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    // TODO: implement build
    return PopupMenuButton(
        icon: Icon(
          Icons.more_horiz,
          color: color,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        onSelected: (value) => onSelected(value),
        color: theme.cardColor,
        itemBuilder: (BuildContext context) {
          return options
              .map(
                (opt) =>
                    getDropDownMenuItem(opt.value, opt.icon, context, theme),
              )
              .toList();
        });
  }
}
