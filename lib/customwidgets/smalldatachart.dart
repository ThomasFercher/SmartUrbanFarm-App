import 'dart:collection';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgs/providers/dashboardProvider.dart';
import '../styles.dart';
import 'dart:math';

class SmallDataChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<Color> gradientColors;
  final SplayTreeMap<DateTime, double> data;
  final double minY;
  final double maxY;
  final List<int> titlesY;

  /// This widget is a Card with a Linechart in it.
  /// You can define a custom title and inject your data with a list.
  /// Define your own Gradient to display under the linechart line.
  SmallDataChart({
    @required this.data,
    @required this.gradientColors,
  })  : spots = getSpots(data.values.toList()),
        minY = getMinY(data.values.toList()),
        maxY = getMaxY(data.values.toList()),
        titlesY = getTitlesY(
          getMinY(data.values.toList()),
          getMaxY(data.values.toList()),
        ); //optimize constructor

  static List<FlSpot> getSpots(List<double> datalist) {
    List<FlSpot> spots = [];
    for (var i = datalist.length - 1; i >= 0; i--) {
      spots.add(new FlSpot(i.toDouble(), datalist[i]));
    }
    return spots;
  }

  static double getMaxY(List<double> datalist) {
    return datalist.reduce(max);
  }

  static double getMinY(List<double> datalist) {
    return datalist.reduce(min);
  }

  static List<int> getTitlesY(double minY, double maxY) {
    int min, max, middle;
    double diff = maxY - minY;
    if (diff >= 10) {
      min = (minY / 10).ceil() * 10;
      max = (maxY / 10).floor() * 10;
      middle = min + ((max - min) / 2).round();
    } else if (diff >= 5) {
      min = (minY / 3).ceil() * 3;
      max = (maxY / 3).floor() * 3;
      middle = -1;
    } else if (diff >= 3) {
      min = (minY / 2).ceil() * 2;
      max = (maxY / 2).floor() * 2;
      middle = -1;
    } else if (diff >= 1) {
      min = minY.floor();
      max = maxY.ceil();
      middle = -1;
    }
    return [min, middle, max];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, d, child) {
        return Container(
          child: Container(
            color: isDark(context) ? Colors.black : Colors.white,
            width: MediaQuery.of(context).size.width,
            child: LineChart(
              mainData(context),
            ),
          ),
        );
      },
    );
  }

  LineChartData mainData(BuildContext context) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: gradientColors[0],
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
          showTitles: false,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: dark_gray, fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            return '';
          },
          margin: 0,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: dark_gray,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            return titlesY.contains(value.toInt())
                ? value.toInt().toString()
                : '';
          },
          reservedSize: 18,
          margin: 5,
        ),
      ),
      minX: 0,
      maxX: 9,
      minY: minY - 1,
      maxY: maxY + 1,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 7,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, dotSize: 7),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.6)).toList(),
          ),
        ),
      ],
    );
  }
}
