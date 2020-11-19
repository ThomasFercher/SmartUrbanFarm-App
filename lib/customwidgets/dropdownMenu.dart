import 'package:flutter/material.dart';

class DropDownMenu extends StatelessWidget {
  final Function onClicked;
  final List<String> actions;
  final Color color;

  const DropDownMenu({
    Key key,
    this.onClicked,
    this.actions,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        elevation: 1,
        icon: Icon(
          Icons.more_horiz,
          color: color,
          size: 28,
        ),
        items: actions.map((String value) {
          return new DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (actions) {
          this.onClicked(actions);
        },
      ),
    );
  }
}
