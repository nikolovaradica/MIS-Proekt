import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static const String apiUrl = "https://zenquotes.io/api/quotes/";

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
        print("Failed to load quotes");
        return [];
        // throw Exception("Failed to load quotes");
      }
    } catch (e) {
      print("Error fetching quotes: $e");
      return [];
      // throw Exception("Error fetching quotes: $e");
    }
  }
}