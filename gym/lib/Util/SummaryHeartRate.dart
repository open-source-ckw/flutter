import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SummaryHeartRate extends StatelessWidget {
  const SummaryHeartRate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25.0),
      height: 150.0,
      width: MediaQuery.of(context).size.width - 15.0,
      child: BarChart(
        BarChartData(
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: 180,
          minY: 0,
        ),
      ),
    );
  }

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              interval: 180,
              getTitlesWidget: getTitlesWidget),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  Widget getTitlesWidget(double value, TitleMeta meta) {
    return Text('$value');
  }

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [BarChartRodData(toY: 55, color: Colors.blue.shade900)],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [BarChartRodData(toY: 60, color: Colors.blue.shade900)],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [BarChartRodData(toY: 65, color: Colors.blue.shade900)],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [BarChartRodData(toY: 70, color: Colors.blue.shade900)],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [BarChartRodData(toY: 75, color: Colors.blue.shade900)],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [BarChartRodData(toY: 170, color: Colors.blue.shade900)],
        ),
      ];
}
