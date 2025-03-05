import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lifelog/models/daily_entry.dart';
import 'package:lifelog/widgets/central_card.dart';
import 'package:lifelog/widgets/gradient_background.dart';
import 'package:lifelog/widgets/mood_pie_chart.dart';
import 'package:lifelog/widgets/section_title.dart';
import 'package:lifelog/widgets/sleep_line_chart.dart';

class ViewGraphsScreen extends StatelessWidget {
  final Map<DateTime, DailyEntry> entries;

  const ViewGraphsScreen({
    super.key,
    required this.entries,
  });

  List<double> calculateSleepData(Map<DateTime, DailyEntry> data, int numEntries) {
    DateTime now = DateTime.now();
    DateTime daysAgo = now.subtract(Duration(days: numEntries));

    var filteredEntries = data.entries.where((entry) {
      return entry.key.isAfter(daysAgo) && entry.key.isBefore(now);
    }).toList();
    filteredEntries.sort((a, b) => a.key.compareTo(b.key));

    return filteredEntries.map((entry) {
      final start = entry.value.sleepStartTime.hour + entry.value.sleepStartTime.minute / 60;
      final end = entry.value.sleepEndTime.hour + entry.value.sleepEndTime.minute / 60;
      return end >= start ? end - start : 24- start + end;
    }).toList();
  }

  double calculateAverageSleep(List<double> sleepData) {
    return sleepData.isEmpty ? 0.0 : sleepData.reduce((a, b) => a+b) / sleepData.length;
  }

  double calculateMaxSleep(List<double> sleepData) {
    return sleepData.isEmpty ? 0.0 : sleepData.reduce(max);
  }

  double calculateMinSleep(List<double> sleepData) {
    return sleepData.isEmpty ? 0.0 : sleepData.reduce(min);
  }

  String formatSleepDuration(double hours) {
    final int hourPart = hours.floor();
    final int minutePart = ((hours - hourPart) * 60).round();
    return '${hourPart}h ${minutePart}min';
  }

  Map<String, int> calculateMoodData(Map<DateTime, DailyEntry> data, int numEntries) {
    DateTime now = DateTime.now();
    DateTime daysAgo = now.subtract(Duration(days: numEntries));

    var filteredEntries = data.entries.where((entry) {
      return entry.key.isAfter(daysAgo) && entry.key.isBefore(now);
    }).toList();
    filteredEntries.sort((a, b) => a.key.compareTo(b.key));

    const moodMap = {'mood_1': 'angry', 'mood_2': 'sad', 'mood_3': 'neutral', 'mood_4': 'happy', 'mood_5': 'super'};
    final moodFrequency = {'angry': 0, 'sad': 0, 'neutral': 0, 'happy': 0, 'super': 0};
    for (final entry in filteredEntries) {
      final moodLabel = moodMap[entry.value.mood];
      moodFrequency[moodLabel!] = (moodFrequency[moodLabel] ?? 0) + 1;
    }
    return moodFrequency;
  }

  List<String> generateMonthlyLabels(Map<DateTime, DailyEntry> data, int numEntries) {
    DateTime now = DateTime.now();
    DateTime daysAgo = now.subtract(Duration(days: numEntries));

    var filteredEntries = data.entries.where((entry) {
      return entry.key.isAfter(daysAgo) && entry.key.isBefore(now);
    }).toList();
    filteredEntries.sort((a, b) => a.key.compareTo(b.key));

    return filteredEntries.take(numEntries).map((entry) {
      return entry.key.day.toString();
    }).toList();
  }

  List<String> generateWeeklyLabels(Map<DateTime, DailyEntry> data) {
    DateTime now = DateTime.now();
    DateTime daysAgo = now.subtract(const Duration(days: 7));

    var filteredEntries = data.entries.where((entry) {
      return entry.key.isAfter(daysAgo) && entry.key.isBefore(now);
    }).toList();
    filteredEntries.sort((a, b) => a.key.compareTo(b.key));

    List<String> labels = [];
    for (var entry in filteredEntries) {
      labels.add(getDayLabel(entry.key));
    }
    return labels;
  }

  String getDayLabel(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday: return 'MON';
      case DateTime.tuesday: return 'TUE';
      case DateTime.wednesday: return 'WED';
      case DateTime.thursday: return 'THU';
      case DateTime.friday: return 'FRI';
      case DateTime.saturday: return 'SAT';
      case DateTime.sunday: return 'SUN';
      default: return '';
    }
  }

  int getDaysInMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    final lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));
    return lastDayOfMonth.day;
  }

  @override
  Widget build(BuildContext context) {
    final weeklySleepData = calculateSleepData(entries, 7);
    final monthlySleepData = calculateSleepData(entries, getDaysInMonth(DateTime.now()));
    final averageSleep = calculateAverageSleep(monthlySleepData);
    final maxSleep = calculateMaxSleep(monthlySleepData);
    final minSleep = calculateMinSleep(monthlySleepData);   
    final weeklyMoodData = calculateMoodData(entries, 7);
    final monthlyMoodData = calculateMoodData(entries, 30);
    final weeklyLabels = generateWeeklyLabels(entries);
    final monthlyLabels = generateMonthlyLabels(entries, getDaysInMonth(DateTime.now()));

    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(showLogo: true),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: CentralCard(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Graph view of your statistics', 
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SectionTitle(title: 'Weekly sleep statistics'),
                          SleepLineChart(
                            sleepData: weeklySleepData, 
                            labels: weeklyLabels,
                          ),
                          const SectionTitle(title: 'Monthly sleep statistics'),
                          SleepLineChart(
                            sleepData: monthlySleepData, 
                            labels: monthlyLabels,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Average Sleep Time: ${formatSleepDuration(averageSleep)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Max Sleep Time: ${formatSleepDuration(maxSleep)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Min Sleep Time: ${formatSleepDuration(minSleep)}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SectionTitle(title: 'Weekly mood statistics'),
                          MoodPieChart(moodData: weeklyMoodData),
                          const SectionTitle(title: 'Monthly mood statistics'),
                          MoodPieChart(moodData: monthlyMoodData),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}