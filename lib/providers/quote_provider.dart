import 'package:flutter/foundation.dart';
import 'package:lifelog/services/quote_service.dart';

class QuoteProvider with ChangeNotifier {
  final QuoteService _quoteService = QuoteService();
  List<Map<String, String>> _quotes = [];
  Map<String, String>? _currentQuote;

  Map<String, String>? get currentQuote => _currentQuote;

  Future<void> loadQuotes() async {
    _quotes = await _quoteService.fetchQuotes();
    _setRandomQuote();
  }

  void _setRandomQuote() {
    if (_quotes.isNotEmpty) {
      _currentQuote = (_quotes..shuffle()).first;
      notifyListeners();
    }
  }
}