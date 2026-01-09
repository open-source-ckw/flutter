import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivitySleepBarChart extends StatelessWidget {
  ActivitySleepBarChart({Key? key}) {
    final barGroup1 = makeGroupData(0, 7);
    final barGroup2 = makeGroupData(1, 8);
    final barGroup3 = makeGroupData(2, 6);
    final barGroup4 = makeGroupData(3, 7.5);
    final barGroup5 = makeGroupData(4, 8.5);
    final barGroup6 = makeGroupData(5, 6.5);
    final barGroup7 = makeGroupData(6, 6);

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(
      barsSpace: 10,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: Colors.blue.shade900,
          width: width,
        ),
      ],
    );
  }

  final double width = 10;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, right: 16, left: 6),
      child: SizedBox(
        height: 50.0,
        width: MediaQuery.of(context).size.width,
        child: BarChart(
          BarChartData(
            maxY: 10,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.grey,
                getTooltipItem: (a, b, c, d) => null,
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  getTitlesWidget: bottomTitles,
                  reservedSize: 42,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 28,
                  interval: 1,
                  getTitlesWidget: leftTitles,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: showingBarGroups,
            gridData: FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = value.toInt().toString();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }
}
