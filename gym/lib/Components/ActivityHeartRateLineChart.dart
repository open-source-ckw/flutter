import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityHeartRateLineChart extends StatelessWidget {
  const ActivityHeartRateLineChart({Key? key}) : super(key: key);

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: false,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('S', style: style);
        break;
      case 2:
        text = const Text('M', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('W', style: style);
        break;
      case 5:
        text = const Text('T', style: style);
        break;
      case 6:
        text = const Text('F', style: style);
        break;
      case 7:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 1,
      child: text,
    );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: false,
        interval: 1,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff75729e),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = value.toInt().toString();
    return Text(text, style: style, textAlign: TextAlign.center);
  }

  FlGridData get gridData => FlGridData(
      show: false, drawHorizontalLine: true, drawVerticalLine: false);

  FlBorderData get borderData => FlBorderData(
        show: false,
        border: const Border(
          bottom: BorderSide(color: Colors.transparent, width: 0),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: false,
        color: Colors.blue.shade900,
        // color: const Color(0xff4af699),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: List.generate(60,
            (index) => FlSpot(index.toDouble(), Random().nextDouble() * 120)),
      );

  LineChartData get sampleData1 => LineChartData(
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 60,
        maxY: 120,
        minY: 0,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 00.0, right: 16, left: 6),
      child: SizedBox(
        height: 50.0,
        width: MediaQuery.of(context).size.width,
        child: LineChart(
          sampleData1,
          swapAnimationDuration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }
}
