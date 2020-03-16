import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: GridView.count(
        padding: EdgeInsets.only(top: 0, left: 15, right: 15),
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        childAspectRatio: 1.25,
        children: <Widget>[
          CardData(
            icon: LineIcons.clone,
            text: "Temperatur",
            child: new Text(
              "30° C",
              style: Theme.of(context).textTheme.display4,
            ),
          ),
          CardData(
            icon: LineIcons.sun_o,
            text: "Luftfeuchtigkeit",
            child: new Text(
              "85%",
              style: Theme.of(context).textTheme.display4,
            ),
          ),
          CardData(
            icon: LineIcons.navicon,
            text: "Current DayTime",
            child: new Text(
              "yee",
              style: Theme.of(context).textTheme.display4,
            ),
          ),
          CardData(
            icon: LineIcons.navicon,
            text: "Current DayTime",
            child: new Text(
              "yee",
              style: Theme.of(context).textTheme.display4,
            ),
          ),
        ],
      ),
    );
  }
}

class CardData extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget child;

  CardData({
    @required this.icon,
    @required this.text,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: InkWell(
        onLongPress: () => temperatureDiagram(context),
        borderRadius: BorderRadius.circular(borderRadius),
        child: Card(
          elevation: getCardElavation(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          color: isDark(context) ? accentColor_d : Colors.white,
          child: Container(
            padding: EdgeInsets.only(left: 3, right: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: new LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            transform:
                                Matrix4.translationValues(0.0, -15.0, 0.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                              elevation: getCardElavation(context),
                              child: Container(
                                height: 40,
                                width: constraints.maxWidth - 8,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Color(
                                        0xFF00ae00,
                                      ),
                                      primaryColor,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment(0.0, 0.0),
                                          height: 40,
                                          child: new Text(
                                            text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment(0.0, 0.0),
                                          height: 40,
                                          child: Icon(
                                            icon,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5, right: 5, top: 0),
                            transform:
                                Matrix4.translationValues(0.0, -15.0, 0.0),
                            child: child,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future temperatureDiagram(context) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: SimpleDialog(
                elevation: getCardElavation(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius + 10)),
                title: Text('Temperaturverlauf'),
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(25),
                    width: 400,
                    child: new Text("Diagram"),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: FlatButton(
                      onPressed: () => print("yee"),
                      child: new Text("Show Diagram"),
                      // color: Colors.black,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: new Text("Close"),
                      // color: Colors.black,
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
