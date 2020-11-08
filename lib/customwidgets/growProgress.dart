import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sgs/styles.dart';

class GrowProgress extends StatelessWidget {
  final double progress;
  final BoxConstraints c;
  GrowProgress(this.c, this.progress);

  FlareControls flrctrl = new FlareControls();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      child: Container(
        height: c.maxHeight - 46,
        width: c.maxWidth,
        child: Stack(
          children: [
            FlareActor(
              'assets/flares/grow.flr',
              alignment: Alignment.center,
              animation: "Growing",
              controller: flrctrl,
              callback: (s) {
                flrctrl.play("Wind");
              },
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: Text(
                "$progress%",
                style: TextStyle(
                  color: getTheme().textColor,
                  fontWeight: FontWeight.w100,
                  fontSize: 30.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
