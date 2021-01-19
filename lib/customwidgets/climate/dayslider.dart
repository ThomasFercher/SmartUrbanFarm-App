import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/providers/settingsProvider.dart';
import 'package:sgs/objects/appTheme.dart';

class DaySlider extends StatefulWidget {
  final Function onValueChanged;
  final String initialTimeString;
 

  /// This widget lets u choose a timerange from 0-24h
  /// The current value is displayed over the slider itself
  /// Also you can use the onValueChanged function to define your own callback function
  DaySlider({@required this.onValueChanged, @required this.initialTimeString, Key key}): super(key: key);

  @override
  _DaySliderState createState() => _DaySliderState();
}

class _DaySliderState extends State<DaySlider> {
  RangeValues _values;
  var labels;
  var suntime;



  @override
  void initState() {
    _values = getValueFromTimeString(widget.initialTimeString);
    labels = [getTimeString(_values.start), getTimeString(_values.end)];
    suntime = (_values.end - _values.start) / 4;
    super.initState();
  }


  String getTimeString(double quarters) {
    int hours = (quarters / 4).floor();
    int minutes = ((quarters - (hours * 4)) * 15).floor();
    String h = hours >= 10 ? "$hours" : "0$hours";
    String m = minutes == 0 ? "0$minutes" : "$minutes";
    return "$h:$m";
  }

  RangeValues getValueFromTimeString(String timestring) {
    String val1 = timestring.split('-')[0];
    String val2 = timestring.split('-')[1];
    return new RangeValues(getRangeValue(val1), getRangeValue(val2));
  }

  double getRangeValue(String value) {
    double hours = double.parse(value.split(":")[0]) * 4;
    double min = double.parse(value.split(":")[1]) / 15;
    return hours + min;
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 15, left: 20, right: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SectionTitle(
                title: "Suntime",
                fontSize: 20,
                color: theme.headlineColor,
              ),
              Text(
                "${getTimeString(suntime * 4)} hours",
                style: TextStyle(
                  color: theme.headlineColor,
                  fontWeight: FontWeight.w100,
                  fontSize: 30.0,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 50,
                  child: FlareActor(
                    'assets/flares/sun.flr',
                    alignment: Alignment.center,
                    animation: "Moon Rings",
                    color: Colors.orange,

                    //  color: Colors.yellow[500],
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 15),
                      rangeThumbShape: _CustomRangeThumbShape(
                        values: labels,
                        valuesTime: _values,
                      ),
                      trackHeight: 2,
                    ),
                    child: RangeSlider(
                        divisions: 96,
                        values: _values,
                        min: 0,
                        max: 96,
                        activeColor: theme.primaryColor,
                        inactiveColor: Colors.black12,
                        onChanged: (values) {
                          setState(
                            () {
                              if (values.end - values.start >= 16)
                                _values = values;
                              labels = [
                                getTimeString(_values.start),
                                getTimeString(_values.end)
                              ];
                              suntime = _values.end / 4 - _values.start / 4;

                              widget.onValueChanged(
                                  labels[0] + " - " + labels[1]);
                            },
                          );
                        }),
                  ),
                ),
                Container(
                  width: 40,
                  height: 50,
                  child: FlareActor(
                    'assets/flares/moon.flr',
                    alignment: Alignment.center,
                    animation: "Moon Rings",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomRangeThumbShape extends RangeSliderThumbShape {
  static const double _thumbSize = 4.0;
  RangeValues valuesTime = new RangeValues(24, 72);
  var values = [];
  Paint _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 1.0
    ..style = PaintingStyle.fill;

  _CustomRangeThumbShape({
    @required this.values,
    @required this.valuesTime,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size(_thumbSize, _thumbSize);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    bool isEnabled,
    bool isOnTop,
    TextDirection textDirection,
    SliderThemeData sliderTheme,
    Thumb thumb,
    bool isPressed,
  }) {
    final Canvas canvas = context.canvas;
    Path oval = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            height: 30,
            width: 42,
          ),
          Radius.circular(15),
        ),
      );
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2)
      ..style = PaintingStyle.fill;
    canvas.drawPath(oval, shadowPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          height: 30,
          width: 42,
        ),
        Radius.circular(15),
      ),
      _paint,
    );

    switch (thumb) {
      case Thumb.start:
        TextSpan span = new TextSpan(
            style: GoogleFonts.nunito(color: Colors.black54, fontSize: 12),
            text: values[0]);
        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(center.dx - 16, center.dy - 8));

        break;
      case Thumb.end:
        TextSpan span = new TextSpan(
          style: GoogleFonts.nunito(color: Colors.black54, fontSize: 12),
          text: values[1],
        );
        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(center.dx - 16, center.dy - 8));

        break;
    }
  }
}
