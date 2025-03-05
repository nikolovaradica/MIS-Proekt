import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SleepLineChart extends StatelessWidget {
  final List<double> sleepData;
  final List<String> labels;

  const SleepLineChart({super.key, required this.sleepData, required this.labels});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                sleepData.length, 
                (index) => FlSpot(index.toDouble(), sleepData[index])
              ),
              isCurved: true,
              color: const Color(0xFF5D9EEA),
              barWidth: 2,
              dotData: const FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    return Text(labels[index], style: const TextStyle(fontSize: 10));
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}h', style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return const Text('');
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return const Text('');
                },
              ),
            ),
          ),
          gridData: const FlGridData(
            show: true,
            drawHorizontalLine: true,
            verticalInterval: 1,
            horizontalInterval: 2,
          ),
        )
      ),
    );
  }
}