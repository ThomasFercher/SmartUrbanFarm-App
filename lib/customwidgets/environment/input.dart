import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/objects/appTheme.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/styles.dart';

import '../sectionTitle.dart';

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
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return Container(
      padding: EdgeInsets.all(20),
      color: theme.background,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 4),
            child: SectionTitle(
              title: "Name",
              fontSize: 20,
              color: theme.headlineColor,
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
                color: theme.headlineColor,
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
