import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class SettingsPage extends StatelessWidget {
  List<Widget> tiles = [
    ListTile(
      title: new Text("Settings"),
    ),
    ListTile(
      leading: Icon(Icons.wifi),
      title: new Text("Wi-Fi Configuration"),
    ),
    ListTile(),
    CheckboxListTile(
      value: true,
      title: Text("This is a CheckBoxPreference"),
      onChanged: (value) {},
    ),
    SwitchListTile(
      value: false,
      title: Text("Take daily picture"),
      onChanged: (value) {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: ListView(
        children: tiles,
      ),
    );
  }
}
