import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../styles.dart';

class TemperatureChart extends StatelessWidget {
  List<FlSpot> spots;
  List<Color> gradientColors = [
    primaryColor,
    const Color(0xff02d39a),
  ];
  List<dynamic> temperatures;

  TemperatureChart({this.temperatures});

  List<FlSpot> getSpots(List<dynamic> temps) {
    List<FlSpot> spots = [];
    for (var i = temps.length - 1; i >= 0; i--) {
      spots.add(new FlSpot(i.toDouble(), double.parse(temps[i])));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LineChart(
        mainData(),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            /*   switch (value.toInt()) {
              case 2:
                return 'Nice';
              case 5:
                return 'Cock';
              case 8:
                return 'SEP';
            }*/
            return '';
          },
          margin: 0,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 21:
                return '20';
              case 30:
                return '30';
              case 39:
                return '40';
            }
            return '';
          },
          reservedSize: 28,
          margin: 10,
        ),
      ),
      minX: 0,
      maxX: 9,
      minY: 20,
      maxY: 40,
      lineBarsData: [
        LineChartBarData(
          spots: getSpots(temperatures),
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
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
