import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/appBarHeader.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/styles.dart';

class SettingsPage extends StatelessWidget {
  List<Widget> getSettings(SettingsProvider pr, context) {
    return [
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        leading: LeadingIcon(icon: Icons.wifi_tethering),
        title: new Text(
          "Wi-Fi Configuration",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: new Text(
          "Bla wlan shit",
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
      CheckboxListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        secondary: LeadingIcon(icon: Icons.wifi_tethering),
        onChanged: (value) => pr.setCheckbox(value),
        value: pr.checkbox,
        title: Text(
          "This is a CheckBoxPreference",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        activeColor: getTheme().background[0],
        checkColor: Colors.white,
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        secondary: LeadingIcon(icon: Icons.camera_alt),
        value: pr.takeDailyPicture,
        activeColor: getTheme().background[0],
        title: Text(
          "Take daily picture",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: new Text(
          "A timelapse will be created",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        onChanged: (value) => pr.setTakeDailyPicture(value),
      ),
      ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        leading: LeadingIcon(icon: Icons.info),
        title: Text(
          "More Information",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: new Text(
          "Information about licenses and version number",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        onTap: () {
          showAboutDialog(
            context: context,
            applicationIcon: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.only(bottom: 5, right: 5),
              child: SvgPicture.asset(
                "assets/leaf.svg",
                color: Colors.green,
              ),
            ),
            applicationLegalese: "",
            applicationVersion: "0.4.4",
            useRootNavigator: true,
            applicationName: "SGS",
          );
        },
      ),
      Container(
        height: 320,
        child: Column(children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            leading: LeadingIcon(icon: Icons.colorize),
            title: Text(
              "Select Color Theme",
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            childAspectRatio: 0.5,
            children: [
              ThemeCard(
                gradient: themes[0].background,
                cardColor: themes[0].cardColor,
                onSelected: () => {pr.setTheme(0)},
                selected: pr.getSelected(0),
                appTheme: themes[0],
              ),
              ThemeCard(
                gradient: themes[1].background,
                cardColor: themes[1].cardColor,
                onSelected: () => {pr.setTheme(1)},
                selected: pr.getSelected(1),
                appTheme: themes[1],
              ),
              ThemeCard(
                gradient: themes[2].background,
                cardColor: themes[2].cardColor,
                onSelected: () => {pr.setTheme(2)},
                selected: pr.getSelected(2),
                appTheme: themes[2],
              ),
            ],
          ),
        ]),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: getTheme().primaryColor,
      ),
      child: AppBarHeader(
          isPage: true,
          title: "Settings",
          theme: getTheme(),
          body: [
            Consumer<SettingsProvider>(builder: (context, pr, child) {
              return Container(
                child: ListView(
                  children: getSettings(pr, context),
                ),
              );
            }),
          ]),
    );
  }
}

class ThemeCard extends StatelessWidget {
  final List<Color> gradient;
  final bool selected;
  final Function onSelected;
  final Color cardColor;
  final AppTheme appTheme;

  ThemeCard(
      {this.gradient,
      this.selected,
      this.onSelected,
      this.cardColor,
      this.appTheme});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var w = constraints.maxWidth;
      return GestureDetector(
        onTap: onSelected,
        child: Card(
          elevation: selected ? 3 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomPaint(
            painter: appTheme.name == "light" ? ThemePainter(appTheme) : null,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  decoration: appTheme.name != "light"
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: gradient,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        )
                      : null,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(bottom: 5)),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(w / 5),
                            ),
                          ),
                        ],
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
      );
    });
  }
}

class LeadingIcon extends StatelessWidget {
  final IconData icon;

  const LeadingIcon({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        color: Colors.black.withOpacity(0.1),
      ),
      child: Icon(
        icon,
        size: 25,
        color: getTheme().background[0],
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
    paint.color = Colors.white;
    paint.style = PaintingStyle.fill;

    var height = 50.0;
    var path = new Path();

    path = new Path();
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height - 10));
    canvas.drawPath(path, paint);
    path.close();

    path = new Path();
    paint.color = appTheme.background[0];
    path.moveTo(0, height);
    path.quadraticBezierTo(
        size.width * 0.25, height - 12, size.width * 0.5, height);
    path.quadraticBezierTo(
        size.width * 0.75, height + 12, size.width * 1.0, height);
    path.lineTo(size.width, 10);
    path.arcToPoint(Offset(size.width - 10, 0),
        radius: Radius.circular(10), clockwise: false);
    path.lineTo(10, 0);
    path.arcToPoint(Offset(0, 10),
        radius: Radius.circular(10), clockwise: false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
