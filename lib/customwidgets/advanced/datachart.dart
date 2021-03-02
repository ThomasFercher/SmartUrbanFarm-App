import 'dart:collection';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/customwidgets/general/popupMenu.dart';
import 'package:sgs/customwidgets/general/sectionTitle.dart';
import 'package:sgs/objects/popupMenuOption.dart';
import 'package:sgs/providers/dataProvider.dart';
import 'package:sgs/providers/settingsProvider.dart';
import '../../styles.dart';
import 'dart:math';
import 'package:sgs/objects/appTheme.dart';

class DataChart extends StatefulWidget {
  final List<Color> gradientColors;
  final SplayTreeMap<DateTime, double> data;
  final String title;
  final List<String> filter_options = ["Current", "Day", "Month"];
  final String unit;

  static DateTime today = DateTime.now();
  static DateTime yesterday = new DateTime(today.year, today.month,
      today.day - 1, today.hour, today.minute, today.second);
  static DateTime todayInMonth = new DateTime(today.year, today.month + 1,
      today.day, today.hour, today.minute, today.second);

  /// This widget is a Card with a Linechart in it.
  /// You can define a custom title and inject your data with a list.
  /// Define your own Gradient to display under the linechart line.
  DataChart({
    this.data,
    this.title,
    this.gradientColors,
    this.unit,
  });

  @override
  _DataChartState createState() => _DataChartState();
}

class _DataChartState extends State<DataChart> {
  String filter;

  List<FlSpot> spots;
  double minY;
  double maxY;
  DateTime start;
  DateTime end;
  List<DateTime> dates;

  @override
  void initState() {
    filter = widget.filter_options[0];
    super.initState();
  }

  List<FlSpot> getSpots(
      SplayTreeMap<DateTime, double> data, DateTimeRange range) {
    List<FlSpot> spots = [];
    var x = 0.0;
    dates = [];
    if (filter == "Current") {
      var i = 0;
      data.forEach((key, value) {
        if (i >= data.length - 11) {
          spots.add(new FlSpot(x, value));
          dates.add(key);
          x++;
        }
        i++;
      });
    } else {
      data.forEach((key, value) {
        if (key.isAfter(range.start) && key.isBefore(range.end)) {
          spots.add(new FlSpot(x, value));
          dates.add(key);
          x++;
        }
      });
    }
    if (spots.isEmpty || spots == null) {
      spots.add(new FlSpot(0, 1));
    }

    if (filter != "Current") {
      if (spots.length > 10) {
        //For day and month use 10 values equally streched over time

      }
    }

    return spots;
  }

  double getMaxY(List<FlSpot> list) {
    List<double> datalist = [];
    list.forEach((element) {
      datalist.add(element.y);
    });
    return datalist.reduce(max);
  }

  double getMinY(List<FlSpot> list) {
    List<double> datalist = [];
    list.forEach((element) {
      datalist.add(element.y);
    });
    return datalist.reduce(min);
  }

  DateTimeRange getTimeRange() {
    switch (filter) {
      case "Day":
        return DateTimeRange(start: DataChart.yesterday, end: DataChart.today);
        break;
      case "Month":
        return DateTimeRange(
            start: DataChart.yesterday, end: DataChart.todayInMonth);
        break;
      case "Current":
        return DateTimeRange(start: DataChart.today, end: DataChart.today);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var range = getTimeRange();
    spots = getSpots(widget.data, range);
    minY = getMinY(spots) - 1;
    maxY = getMaxY(spots) + 1;
    AppTheme theme = Provider.of<SettingsProvider>(context).getTheme();

    return Consumer<DataProvider>(
      builder: (context, d, child) {
        return Container(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: SectionTitle(
                      title: widget.title + " [${widget.unit}]",
                      fontSize: 24,
                      color: theme.headlineColor,
                    ),
                  ),
                  PopupMenu(
                    color: theme.textColor,
                    options: widget.filter_options
                        .map((filter) => PopupMenuOption(filter, null))
                        .toList(),
                    onSelected: (v) {
                      setState(() {
                        filter = v;
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(bottom: 10, right: 22, left: 4),
              child: LineChart(
                mainData(context, spots),
                swapAnimationDuration: Duration(milliseconds: 200),
              ),
            ),
          ]),
        );
      },
    );
  }

  LineChartData mainData(BuildContext context, List<FlSpot> spots) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: widget.gradientColors[0],
          getTooltipItems: (List<LineBarSpot> spots) {
            List<LineTooltipItem> l = [];

            spots.forEach((element) {
              l.add(
                new LineTooltipItem(
                  element.y.toString(),
                  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              );
            });
            return l;
          },
          fitInsideVertically: true,
          tooltipRoundedRadius: borderRadius,
          tooltipBottomMargin: 40,
          tooltipPadding: EdgeInsets.only(top: 6, left: 8, right: 8, bottom: 6),
        ),
      ),
      gridData: FlGridData(
        show: false,
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          interval: 5,
          textStyle: const TextStyle(
              color: dark_gray, fontWeight: FontWeight.bold, fontSize: 14),
          getTitles: (value) {
            if (value < dates.length) {
              var v = dates[value.toInt()];
              switch (filter) {
                case "Day":
                  var h = v.hour;
                  var m = v.minute;
                  var m_s = m < 10 ? "0$m" : "$m";

                  return "$h:$m_s";
                  break;
                case "Month":
                  var d = v.day;
                  var m = v.month;

                  return "$d.$m";
                  break;
                case "Current":
                  var h = v.hour;
                  var m = v.minute;
                  var m_s = m < 10 ? "0$m" : "$m";

                  return "$h:$m_s";
                  break;
                default:
              }
            }
          },
          margin: 10,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: dark_gray,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          interval: 3,
          getTitles: (value) {
            return "${value.toInt()}";
          },
          reservedSize: 20,
          margin: 5,
        ),
      ),
      minX: 0,
      maxX: spots.length - 1.0,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: widget.gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, dotSize: 5),
          belowBarData: BarAreaData(
            show: true,
            colors: widget.gradientColors
                .map((color) => color.withOpacity(0.6))
                .toList(),
          ),
        ),
      ],
    );
  }
}
