import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/general/appBarHeader.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/styles.dart';
import 'package:sgs/objects/appTheme.dart';

class SettingsPage extends StatelessWidget {
  List<Widget> getSettings(SettingsProvider pr, context) {
    AppTheme theme = pr.getTheme();
    List<AppTheme> themes = pr.themes;

    return [
      Padding(
        padding: EdgeInsets.only(top: 20),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        secondary: LeadingIcon(icon: Icons.camera_alt),
        value: pr.settings.automaticTimeLapse,
        inactiveTrackColor: theme.contrast,
        activeColor: theme.primaryColor,
        title: Text(
          "Take daily picture",
          style: GoogleFonts.nunito(
            color: theme.headlineColor,
          ),
        ),
        subtitle: new Text(
          "A timelapse will be created",
          style: GoogleFonts.nunito(
            color: theme.headlineColor,
          ),
        ),
        onChanged: (value) => pr.setAutomaticTimeLapse(value),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        secondary: LeadingIcon(icon: Icons.notifications),
        value: pr.settings.notifications,
        inactiveTrackColor: theme.contrast,
        activeColor: theme.primaryColor,
        title: Text(
          "Notifications",
          style: GoogleFonts.nunito(
            color: theme.headlineColor,
          ),
        ),
        subtitle: new Text(
          "Enable or Disable Notifications",
          style: GoogleFonts.nunito(
            color: theme.headlineColor,
          ),
        ),
        onChanged: (value) => pr.setNotifications(value),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        leading: LeadingIcon(icon: Icons.info),
        title: Text(
          "More Information",
          style: GoogleFonts.nunito(
            color: theme.headlineColor,
          ),
        ),
        subtitle: new Text(
          "Information about licenses and version number",
          style: GoogleFonts.nunito(
            color: theme.headlineColor,
          ),
        ),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationIcon: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.only(bottom: 5, right: 5),
              child: Container(),
            ),
            applicationLegalese: "",
            applicationVersion: "0.4.4",
            useRootNavigator: true,
            applicationName: "SGS",
          );
        },
      ),
      Container(
        child: Column(children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            leading: LeadingIcon(icon: Icons.colorize),
            title: Text(
              "Select Color Theme",
              style: GoogleFonts.nunito(
                color: theme.headlineColor,
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            childAspectRatio: 0.5,
            children: [
              ThemeCard(
                background: themes[0].background,
                cardColor: themes[0].cardColor,
                onSelected: () => {pr.setTheme(0)},
                selected: pr.getSelected(0),
                appTheme: themes[0],
              ),
              /*   ThemeCard(
                gradient: themes[1].background,
                cardColor: themes[1].cardColor,
                onSelected: () => {pr.setTheme(1)},
                selected: pr.getSelected(1),
                appTheme: themes[1],
              ),*/
              ThemeCard(
                background: themes[1].background,
                cardColor: themes[1].cardColor,
                onSelected: () => {pr.setTheme(1)},
                selected: pr.getSelected(1),
                appTheme: themes[1],
              ),
            ],
          ),
        ]),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, pr, child) {
        return AppBarHeader(
          isPage: true,
          title: "Settings",
          body: getSettings(pr, context),
        );
      },
    );
  }
}

class ThemeCard extends StatelessWidget {
  final Color background;
  final bool selected;
  final Function onSelected;
  final Color cardColor;
  final AppTheme appTheme;

  ThemeCard({
    this.background,
    this.selected,
    this.onSelected,
    this.cardColor,
    this.appTheme,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var w = constraints.maxWidth;
      return GestureDetector(
        onTap: onSelected,
        child: SizedBox(
          height: constraints.maxHeight + 8,
          child: Card(
            color:
                appTheme.name == "light" ? Colors.grey[50] : Colors.grey[800],
            elevation: selected ? 3 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: CustomPaint(
              painter: ThemePainter(appTheme),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                color: cardColor,
                                elevation: 1,
                                child: Container(
                                  width: w / 5,
                                  height: w / 5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(w / 5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              color: cardColor,
                              elevation: 1,
                              child: Container(
                                width: w / 5,
                                height: w / 5,
                              ),
                            ),
                            Card(
                              color: cardColor,
                              elevation: 1,
                              child: Container(
                                width: w / 5,
                                height: w / 5,
                              ),
                            ),
                            Card(
                              color: cardColor,
                              elevation: 1,
                              child: Container(
                                width: w / 5,
                                height: w / 5,
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 15)),
                        Card(
                          color: cardColor,
                          elevation: 1,
                          child: Container(
                            width: w,
                            height: w / 5,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 15)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Card(
                              color: cardColor,
                              elevation: 1,
                              child: Container(
                                width: 2 * w / 5,
                                height: 2 * w / 5,
                              ),
                            ),
                            Card(
                              color: cardColor,
                              elevation: 1,
                              child: Container(
                                width: w / 5,
                                height: 2 * w / 5,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  selected
                      ? Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.all(5),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class LeadingIcon extends StatelessWidget {
  final IconData icon;

  const LeadingIcon({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        color: theme.contrast,
      ),
      child: Icon(
        icon,
        size: 25,
        color: theme.primaryColor,
      ),
    );
  }
}

class ThemePainter extends CustomPainter {
  final AppTheme appTheme;
  ThemePainter(this.appTheme);
  //drawing
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.style = PaintingStyle.fill;

    var height = 60.0;
    var path = new Path();

    paint.color = appTheme.primaryColor;
    path.moveTo(0, height);

    path.lineTo(size.width, height);
    path.lineTo(size.width, borderRadius);

    path.arcToPoint(Offset(size.width - borderRadius, 0),
        radius: Radius.circular(borderRadius), clockwise: false);
    path.lineTo(borderRadius, 0);

    path.arcToPoint(Offset(0, borderRadius),
        radius: Radius.circular(borderRadius), clockwise: false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
