import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeightProgressLineChart extends StatelessWidget {
  const WeightProgressLineChart({Key? key}) : super(key: key);

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
        showTitles: true,
        reservedSize: 49,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    const darkStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    DateTime currentDate = DateTime.now();
    int day = DateTime.now()
        .difference(DateTime.parse("${currentDate.year}-01-01"))
        .inDays;
    int addWeekDay = (day % 7) == 0 ? 0 : 1;
    int week = (day / 7).floor() + addWeekDay;
    switch (value.toInt()) {
      case 1:
        text = Text('${week - 6}', style: style);
        break;
      case 2:
        text = Text('${week - 5}', style: style);
        break;
      case 3:
        text = Text('${week - 4}', style: style);
        break;
      case 4:
        text = Text('${week - 3}', style: style);
        break;
      case 5:
        text = Text('${week - 2}', style: style);
        break;
      case 6:
        text = Text('${week - 1}', style: style);
        break;
      case 7:
        text = Text('$week', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(axisSide: meta.axisSide, space: 10, child: text
        /*Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.blue.shade900),
          child: text),*/
        );
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
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

  FlGridData get gridData =>
      FlGridData(show: true, drawHorizontalLine: true, drawVerticalLine: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
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
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 53.2),
          FlSpot(2, 53),
          FlSpot(3, 52.9),
          FlSpot(4, 52.7),
          FlSpot(5, 53),
          FlSpot(6, 52.5),
          FlSpot(7, 52.9),
        ],
      );

  LineChartData get sampleData1 => LineChartData(
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 8,
        maxY: 55,
        minY: 50,
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, right: 16, left: 6),
      child: SizedBox(
        height: 250.0,
        width: MediaQuery.of(context).size.width,
        child: LineChart(
          sampleData1,
          swapAnimationDuration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }
}
