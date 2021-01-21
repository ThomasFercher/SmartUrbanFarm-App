import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Icon(
        Icons.info,
        color: Colors.black38,
      ),
    );
  }
}
