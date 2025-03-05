import 'package:flutter/material.dart';
import 'package:lifelog/models/daily_entry.dart';
import 'package:lifelog/services/daily_entry_service.dart';

class DailyEntryProvider with ChangeNotifier {
  final DailyEntryService _service = DailyEntryService();
  Map<DateTime, DailyEntry> _entries = {};

  Map<DateTime, DailyEntry> get entries => Map.from(_entries);

  Future<void> fetchEntries(String userId) async {
    _entries.clear();
    _entries = await _service.fetchDailyEntries(userId);
    notifyListeners();
  } 

  Future<void> addEntry(DailyEntry entry, DateTime date) async {
    await _service.addDailyEntry(entry, date);
    fetchEntries(entry.userId);
    notifyListeners();
  }
}