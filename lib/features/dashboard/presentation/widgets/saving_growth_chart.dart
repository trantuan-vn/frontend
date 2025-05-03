import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SavingGrowthChart extends StatelessWidget {
  const SavingGrowthChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: 5000,
        titlesData: FlTitlesData(
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const months = ['Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
                return Text(months[value.toInt()]);
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.purple,
            dotData: FlDotData(show: true),
            belowBarData:
                BarAreaData(show: true, color: Colors.purple.withOpacity(0.3)),
            spots: const [
              FlSpot(0, 1400),
              FlSpot(1, 1800),
              FlSpot(2, 4600),
              FlSpot(3, 700),
              FlSpot(4, 2200),
              FlSpot(5, 0)
            ],
          ),
        ],
      ),
    );
  }
}
