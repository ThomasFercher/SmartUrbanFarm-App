import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../objects/appTheme.dart';
import '../../providers/settingsProvider.dart';
import '../../styles.dart';

class GrowProgress extends StatelessWidget {
  final double progress;
  final BoxConstraints c;
  GrowProgress(this.c, this.progress);

  FlareControls flrctrl = new FlareControls();

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      color: theme.cardColor,
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
                  color: theme.textColor,
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
