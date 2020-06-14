import 'package:flutter/material.dart';
import 'package:sgs/styles.dart';
import 'package:flutter/cupertino.dart';

class CardData extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;
  final Color iconColor;

  /// This widget displays a given text with a label and icon
  /// All this is displayed in a card
  CardData({
    @required this.icon,
    @required this.text,
    @required this.label,
    @required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    color: iconColor,
                  ),
                ),
                Container(
                  child: new Text(
                    label,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Container(
                  child: new Text(
                    text,
                    style: Theme.of(context).textTheme.headline1,
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
