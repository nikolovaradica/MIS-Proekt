import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class QuoteService {
  static const String apiUrl = "https://zenquotes.io/api/quotes/";
  final Logger _logger = Logger();

  Future<List<Map<String, String>>> fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((quote) {
          return {
            "quote": quote["q"] as String,
            "author": quote["a"] as String
          };
        }).toList();
      } else {
        _logger.e("Failed to load quotes");
        return [];
      }
    } catch (e) {
      _logger.e("Error fetching quotes", error: e);
      return [];
    }
  }
}