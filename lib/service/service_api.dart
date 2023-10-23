import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:developer' as logger show log;
import 'package:http/http.dart' as http;

Future<List?> fetchWpPosts(categoryPost) async {
  // final Uri url =
  //     Uri.parse("https://dispora.di-mep.com/wp-json/wp/v2/posts?_embed");
  final Uri url = Uri.parse(
      "https://dispora.pekanbaru.go.id/wp-json/wp/v2/posts?_embed&categories=$categoryPost");
  try {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
      return convertedDatatoJson;
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load posts: $e');
  }
}

Future fetchWpPostImage(String href) async {
  final Uri url = Uri.parse(href);
  try {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
      return convertedDatatoJson;
    } else {
      throw Exception('Failed to load post image: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load post image: $e');
  }
}

Future fetchFasilitasImage(String href) async {
  final Uri url = Uri.parse(href);
  try {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
      return convertedDatatoJson;
    } else {
      throw Exception('Failed to load post image: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load post image: $e');
  }
}

Future<List?> fetchWpVenue() async {
  final Uri url = Uri.parse(
      "https://dispora.pekanbaru.go.id/wp-json/wp/v2/media?parent=6631");
  try {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
      if (kDebugMode) {
        //logger.log("fetchWpVenue => $convertedDatatoJson");
      }
      return convertedDatatoJson;
    } else {
      throw Exception('Failed to load venue: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load venue: $e');
  }
}

Future<List?> fetchFasilitas() async {
  final Uri url = Uri.parse(
      "https://dispora.pekanbaru.go.id/wp-json/wp/v2/pages?per_page=100&parent=0&_embed");
  try {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
      if (kDebugMode) {
        logger.log("fetchFasilitas => $convertedDatatoJson");
      }
      return convertedDatatoJson;
    } else {
      throw Exception('Failed to load fasiitas: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load fasilitas: $e');
  }
}

Future<List?> fetchWpDetailVenue() async {
  final Uri url =
      Uri.parse("https://dispora.pekanbaru.go.id/wp-json/wp/v2/pages?_embed");
  try {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
      if (kDebugMode) {
        //logger.log("fetchWpVenue => $convertedDatatoJson");
      }
      return convertedDatatoJson;
    } else {
      throw Exception('Failed to load venue detail: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load venue detail: $e');
  }
}

Future<List?> fetchWpMedia() async {
  final Uri url =
      Uri.parse("https://dispora.pekanbaru.go.id/wp-json/wp/v2/media");
  try {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
      if (kDebugMode) {
        //logger.log("fetchWpMedia => $convertedDatatoJson");
      }
      return convertedDatatoJson;
    } else {
      throw Exception('Failed to load media: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load media: $e');
  }
}

Future fetchWpPostCategory(String href) async {
  final Uri url = Uri.parse(href);
  try {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
      return convertedDatatoJson;
    } else {
      throw Exception('Failed to load post category: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load post category: $e');
  }
}

Future fetchWpCategory() async {
  final Uri url = Uri.parse(
      "https://dispora.pekanbaru.go.id/wp-json/wp/v2/categories?_embed");
  try {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      var convertedDatatoJson = jsonDecode(response.body);
      return convertedDatatoJson;
    } else {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load categories: $e');
  }
}

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
