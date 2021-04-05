import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../objects/appTheme.dart';
import '../../../providers/settingsProvider.dart';
import '../../../styles.dart';
import '../../general/sectionTitle.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 2.5),
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SectionTitle(
                      title: "Name", fontSize: 24, color: theme.headlineColor),
                ),
                SizedBox(
                  height: 48,
                  child: TextFormField(
                    cursorColor: theme.primaryColor,
                    initialValue: initialValue,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 1.5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: theme.primaryColor, width: 1.5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black12, width: 1.5),
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
                      color: theme.textColor,
                      fontSize: 20,
                      height: 1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
