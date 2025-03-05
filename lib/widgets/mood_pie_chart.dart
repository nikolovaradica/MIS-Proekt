import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoodPieChart extends StatelessWidget {
  final Map<String, int> moodData;
  
  const MoodPieChart({super.key, required this.moodData});

  @override
  Widget build(BuildContext context) {
    final total = moodData.values.reduce((a, b) => a + b);
    final shades = [
      const Color.fromARGB(255, 139, 193, 255),
      const Color.fromARGB(255, 153, 153, 255),
      const Color.fromARGB(255, 181, 144, 255),
      const Color.fromARGB(255, 114, 161, 255),
      const Color.fromARGB(255, 172, 166, 255),
    ];

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: moodData.entries.map((entry) {
            final moodLabel = entry.key;
            final frequency = entry.value;
            final percentage = (frequency/total) * 100;

            final index = moodData.keys.toList().indexOf(moodLabel);
            final color = shades[index % shades.length];

            return PieChartSectionData(
              color: color,
              value: percentage,
              title: '$moodLabel\n${percentage.toStringAsFixed(1)}%',
              radius: 100,
              titleStyle: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            );
          }).toList(),
        )
      ),
    );
  }  
}