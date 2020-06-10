import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../styles.dart';
import 'dart:math';

class DataChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<Color> gradientColors;
  final SplayTreeMap<DateTime, double> data;
  final String title;
  final double minY;
  final double maxY;
  final List<int> titlesY;

  DataChart({
    @required this.data,
    @required this.title,
    this.gradientColors,
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
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10,top: 10),
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(bottom: 15, left: 3),
          alignment: Alignment.centerLeft,
          child: new Text(this.title,
              style: sectionTitleStyle(
                  context, isDark(context) ? dark_gray : text_gray)),
        ),
        ClipRRect(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(right: 10),
            child: Card(
              color: isDark(context) ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              elevation: cardElavation,
              child: Container(
                padding: EdgeInsets.only(left: 5),
                child: LineChart(mainData()),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  LineChartData mainData() {
    return LineChartData(
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
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true, dotSize: 6),
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
