import 'package:flutter/material.dart';
import 'package:sgs/styles.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math.dart' as Vector;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class WaterTankLevel extends StatelessWidget {
  final double fullness;
  //controller for animation
  WaterTankLevel({@required this.fullness});

  @override
  Widget build(BuildContext context) {
    Size size = new Size(MediaQuery.of(context).size.width, 240.0);

    double _yOffset = (200 / 100) * (100 - fullness);
    int yOffset = _yOffset.round();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: getCardElavation(context),
      color: getTheme().cardColor,
      child: Container(
        height: 240,
        width: 120,
        child: fullness > 8
            ? Stack(
                children: [
                  new AnimationBody(
                      size: size,
                      xOffset: 0,
                      yOffset: 5 + yOffset,
                      color: Colors.blueAccent),
                  new Opacity(
                    opacity: 0.5,
                    child: new AnimationBody(
                      size: size,
                      xOffset: 80,
                      yOffset: 10 + yOffset,
                      color: Colors.blueAccent,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.topCenter,
                    child: Text(
                      "$fullness%",
                      style: TextStyle(
                        color: getTheme().textColor,
                        fontWeight: FontWeight.w100,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                alignment: Alignment.center,
                child: new Text(
                  "Empty",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
      ),
    );
  }
}

class AnimationBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;

  AnimationBody(
      {Key key, @required this.size, this.xOffset, this.yOffset, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _AnimationBodyState();
  }
}

class _AnimationBodyState extends State<AnimationBody>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
          i <= widget.size.width.toInt() + 2;
          i++) {
        animList1.add(
          new Offset(
              i.toDouble() + widget.xOffset,
              sin((animationController.value * 360 - i) %
                          360 *
                          Vector.degrees2Radians) *
                      20 +
                  20 +
                  widget.yOffset),
        );
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: new AnimatedBuilder(
        animation: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeInOut,
        ),
        builder: (context, child) => new ClipPath(
          child: new Container(
            width: widget.size.width,
            height: widget.size.height,
            color: widget.color,
          ),
          clipper: new WaveClipper(animationController.value, animList1),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height - 8);
    path.arcToPoint(Offset(size.width - 8, size.height),
        radius: Radius.circular(borderRadius));
    path.lineTo(8, size.height);
    path.arcToPoint(Offset(0, size.height - 8),
        radius: Radius.circular(borderRadius));

    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
