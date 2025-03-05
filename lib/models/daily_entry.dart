import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DailyEntry {
  final String userId;
  final String mood;
  final TimeOfDay sleepStartTime;
  final TimeOfDay sleepEndTime;
  final String gratefulFor;
  final String highlights;
  final LatLng? location;
  String photoOfTheDayPath;

  DailyEntry({
    required this.userId,
    required this.mood,
    required this.sleepStartTime,
    required this.sleepEndTime,
    required this.gratefulFor,
    required this.highlights,
    this.location,
    required this.photoOfTheDayPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mood': mood,
      'sleepStartTime': _formatTimeOfDay(sleepStartTime),
      'sleepEndTime': _formatTimeOfDay(sleepEndTime),
      'gratefulFor': gratefulFor,
      'highlights': highlights,
      'location': {'latitude': location!.latitude, 'longitude': location!.longitude},
      'photoOfTheDayPath': photoOfTheDayPath,
    };
  }

  factory DailyEntry.fromMap(Map<String, dynamic> map) {
    return DailyEntry(
      userId: map['userId'],
      mood: map['mood'],
      sleepStartTime: _parseTime(map['sleepStartTime']),
      sleepEndTime: _parseTime(map['sleepEndTime']),
      gratefulFor: map['gratefulFor'],
      highlights: map['highlights'],
      location: LatLng(map['location']['latitude'], map['location']['longitude']),
      photoOfTheDayPath: map['photoOfTheDayPath'],
    );
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final time = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}