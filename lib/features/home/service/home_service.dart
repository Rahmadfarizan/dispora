import 'dart:convert';
import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HomeServiceApi {
  Future<List?> fetchPosts(categoryPost) async {
    // final Uri url =
    //     Uri.parse("https://dispora.di-mep.com/wp-json/wp/v2/posts?_embed");
    final Uri url = Uri.parse(
        "https://dispora.pekanbaru.go.id/wp-json/wp/v2/posts?_embed&categories=$categoryPost");
    try {
      final response =
          await http.get(url, headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
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

  Future<List?> fetchWpMedia() async {
    final Uri url =
        Uri.parse("https://dispora.pekanbaru.go.id/wp-json/wp/v2/media");
    try {
      final response =
          await http.get(url, headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        if (kDebugMode) {
          logger.log("fetchWpMedia => $convertedDatatoJson");
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
}
