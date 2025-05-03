import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class IncomeChart extends StatefulWidget {
  const IncomeChart({super.key});

  @override
  IncomeChartState createState() => IncomeChartState();
}

class IncomeChartState extends State<IncomeChart> {
  bool isIncomeSelected = true;
  int touchedIndex = -1;

  final List<Map<String, dynamic>> incomeData = [
    {'color': Colors.blue, 'value': 300, 'label': 'Salary'},
    {'color': Colors.green, 'value': 700, 'label': 'Freelance'},
    {'color': Colors.purple, 'value': 900, 'label': 'Investments'},
  ];

  final List<Map<String, dynamic>> expenseData = [
    {'color': Colors.red, 'value': 400, 'label': 'Rent'},
    {'color': Colors.orange, 'value': 500, 'label': 'Utilities'},
    {'color': Colors.grey, 'value': 200, 'label': 'Miscellaneous'},
  ];

  @override
  Widget build(BuildContext context) {
    final data = isIncomeSelected ? incomeData : expenseData;
    final total = data.fold<double>(0, (sum, item) => sum + item['value']);

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final chartSize = constraints.maxWidth < constraints.maxHeight
                ? constraints.maxWidth * 0.45
                : constraints.maxHeight * 0.45;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Financial Overview",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      isSelected: [isIncomeSelected, !isIncomeSelected],
                      borderRadius: BorderRadius.circular(10),
                      selectedColor: Colors.white,
                      fillColor: Colors.blueAccent,
                      color: Colors.black54,
                      constraints:
                          const BoxConstraints(minHeight: 36, minWidth: 100),
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("Income"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("Expense"),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          isIncomeSelected = index == 0;
                          touchedIndex = -1;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: chartSize,
                      width: chartSize,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    response == null ||
                                    response.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = response
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          sections: data.asMap().entries.map((entry) {
                            final index = entry.key;
                            final item = entry.value;
                            final percentage = (item['value'] / total) * 100;
                            final isTouched = index == touchedIndex;

                            return PieChartSectionData(
                              color: item['color'],
                              value: item['value'].toDouble(),
                              title: '${percentage.toStringAsFixed(1)}%',
                              titleStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isTouched
                                    ? chartSize * 0.09
                                    : chartSize * 0.08,
                              ),
                              radius: isTouched
                                  ? chartSize * 0.5
                                  : chartSize * 0.45,
                            );
                          }).toList(),
                          sectionsSpace: 2,
                          centerSpaceRadius: chartSize * 0.2,
                          startDegreeOffset: -90,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final percentage = (item['value'] / total) * 100;
                        final isSelected = touchedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              touchedIndex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? item['color'].withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: item['color'],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Text(
                                  '${item['label']} - ${item['value']} (${percentage.toStringAsFixed(1)}%)',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
