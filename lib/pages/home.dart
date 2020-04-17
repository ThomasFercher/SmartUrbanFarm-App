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
        padding: EdgeInsets.only(top: 0, left: 10, right: 10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: <Widget>[
          CardData(
            icon: LineIcons.clone,
            label: "Temperatur",
            text: "30°C",
          ),
          CardData(
            icon: LineIcons.sun_o,
            label: "Luftfeuchtigkeit",
            text: "85%",
          ),
          CardData(
            icon: LineIcons.navicon,
            label: "DayTime",
            text: "30°C",
          ),
          CardData(
            icon: LineIcons.navicon,
            label: "DayTime",
            text: "30°C",
          ),
          CardData(
            icon: LineIcons.sun_o,
            label: "Luftfeuchtigkeit",
            text: "85%",
          ),
          CardData(
            icon: LineIcons.sun_o,
            label: "Luftfeuchtigkeit",
            text: "85%",
          ),
        ],
      ),
    );
  }
}

class CardData extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;
  

  CardData({
    @required this.icon,
    @required this.text,
    @required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(
                      icon,
                      size: 20,
                    ),
                  ),
                  Container(
                    child: new Text(
                      label,
                      style: Theme.of(context).textTheme.display3,
                    ),
                  ),
                  Container(
                    child: new Text(
                      text,
                      style: Theme.of(context).textTheme.display4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future temperatureDiagram(context) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.8),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: SimpleDialog(
                backgroundColor: accentColor_d,
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
                      color: primaryColor,
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
