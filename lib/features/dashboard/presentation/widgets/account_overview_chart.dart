import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AccountOverviewChart extends StatelessWidget {
  const AccountOverviewChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 3,
        minY: 0,
        maxY: 1000,
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr'];
                return Text(months[value.toInt()]);
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            belowBarData:
                BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
            spots: const [
              FlSpot(0, 300),
              FlSpot(1, 700),
              FlSpot(2, 900),
              FlSpot(3, 0)
            ],
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.purple,
            belowBarData:
                BarAreaData(show: true, color: Colors.purple.withOpacity(0.3)),
            spots: const [
              FlSpot(0, 300),
              FlSpot(1, 200),
              FlSpot(2, 150),
              FlSpot(3, 0)
            ],
          ),
        ],
      ),
    );
  }
}
