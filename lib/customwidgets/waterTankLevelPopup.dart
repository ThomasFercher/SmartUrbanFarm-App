import 'package:flutter/cupertino.dart';
import 'package:sgs/customwidgets/waterTankLevel.dart';

class WaterTankLevelPopup extends StatelessWidget {
  final double fulnness;

  WaterTankLevelPopup({
    this.fulnness,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WaterTankLevel(
        fullness: fulnness,
        height: 400,
        width: 260,
      ),
    );
  }
}
