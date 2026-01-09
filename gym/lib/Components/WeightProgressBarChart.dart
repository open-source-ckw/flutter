import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightProgressBarChart extends StatelessWidget {
  final List<BarChartGroupData> barChartGroupData;

  WeightProgressBarChart({super.key, required this.barChartGroupData}) {
    rawBarGroups = barChartGroupData;
    showingBarGroups = rawBarGroups;
  }

  final double width = 7;

  late final List<BarChartGroupData> rawBarGroups;
  late final List<BarChartGroupData> showingBarGroups;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, right: 16, left: 6, bottom: 50),
      child: SizedBox(
        height: 250.0,
        width: MediaQuery.of(context).size.width,
        child: BarChart(
          BarChartData(
            maxY: 500,
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
                  showTitles: true,
                  getTitlesWidget: bottomTitles,
                  reservedSize: 42,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: 100,
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
    DateTime startDate = DateTime.now();
    DateFormat format = DateFormat("dd");

    final titles = <String>[
      format.format(startDate.subtract(const Duration(days: 6))),
      format.format(startDate.subtract(const Duration(days: 5))),
      format.format(startDate.subtract(const Duration(days: 4))),
      format.format(startDate.subtract(const Duration(days: 3))),
      format.format(startDate.subtract(const Duration(days: 2))),
      format.format(startDate.subtract(const Duration(days: 1))),
      format.format(startDate.subtract(const Duration(days: 0))),
    ];

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
