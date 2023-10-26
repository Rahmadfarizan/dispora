import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchYouTubeVideoInfo(String videoUrl) async {
  final url =
      Uri.parse('https://www.youtube.com/oembed?url=$videoUrl&format=json');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load YouTube video info: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load YouTube video info: $e');
  }
}
