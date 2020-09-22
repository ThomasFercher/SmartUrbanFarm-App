import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sgs/customwidgets/s_g_s__custom_icon_icons.dart';
import 'package:weather_icons/weather_icons.dart';
import '../styles.dart';

class DaySlider extends StatefulWidget {
  final Function onValueChanged;
  final String initialTimeString;

  /// This widget lets u choose a timerange from 0-24h
  /// The current value is displayed over the slider itself
  /// Also you can use the onValueChanged function to define your own callback function
  DaySlider({@required this.onValueChanged, @required this.initialTimeString});

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
    AppTheme theme = getTheme();
    return Card(
      elevation: cardElavation,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.white,
        ),
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Column(
            children: <Widget>[
              Container(
                child: new Text(
                  "${getTimeString(suntime * 4)} hours",
                  style: TextStyle(
                    color: theme.secondaryTextColor,
                    fontWeight: FontWeight.w100,
                    fontSize: 26.0,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Icon(
                        WeatherIcons.day_sunny,
                        //    color: isDark(context) ? Colors.white : Colors.black54,
                        color: Colors.deepOrange[500],
                      ),
                    ),
                    Container(
                      constraints:
                          BoxConstraints(maxWidth: getWidth(context) - 136),
                      child: SliderTheme(
                        data: SliderThemeData(
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 22),
                          rangeThumbShape: _CustomRangeThumbShape(
                              values: labels, valuesTime: _values),
                          trackHeight: 5,
                        ),
                        child: RangeSlider(
                          divisions: 96,
                          values: _values,
                          min: 0,
                          max: 96,
                          activeColor: theme.primaryColor,
                          inactiveColor: Colors.black12,
                          onChanged: (values) => setState(
                            () {
                              if (values.end - values.start >= 16)
                                _values = values;
                              labels = [
                                getTimeString(_values.start),
                                getTimeString(_values.end)
                              ];
                              suntime = _values.end / 4 - _values.start / 4;
                              widget.onValueChanged(labels);
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(
                        SGSCustomIcon.uniF02E,
                        //  color: isDark(context) ? Colors.white : Colors.black54,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      ..addOval(new Rect.fromCenter(center: center, width: 40, height: 40));
    Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1)
      ..style = PaintingStyle.fill;
    canvas.drawPath(oval, shadowPaint);
    canvas.drawCircle(center, 20, _paint);

    switch (thumb) {
      case Thumb.start:
        TextSpan span = new TextSpan(
            style: new TextStyle(color: Colors.black54, fontSize: 14),
            text: values[0]);
        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(center.dx - 18, center.dy - 7));

        break;
      case Thumb.end:
        TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.black54, fontSize: 14),
          text: values[1],
        );
        TextPainter tp = new TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(center.dx - 18, center.dy - 7));

        break;
    }
  }
}

void drawCircle(Offset thumbCenter, canvas, _paint) {
  canvas.drawCircle(thumbCenter, 16.0, _paint);
}
