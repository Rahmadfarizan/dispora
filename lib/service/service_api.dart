import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'dart:developer' as logger show log;
import 'package:http/http.dart' as http;

Future<List?> fetchWpPosts() async {
  final Uri url =
      Uri.parse("https://dispora.di-mep.com/wp-json/wp/v2/posts?_embed");
  final response = await http.get(url, headers: {"Accept": "application/json"});

  var convertedDatatoJson = jsonDecode(response.body);

  return convertedDatatoJson;
}

Future fetchWpPostImage(String href) async {
  final Uri url = Uri.parse(href);
  final response = await http.get(url, headers: {"Accept": "application/json"});

  var convertedDatatoJson = jsonDecode(response.body);

  return convertedDatatoJson;
}

Future<List?> fetchWpVenue() async {
  final Uri url =
      Uri.parse("https://dispora.di-mep.com/wp-json/wp/v2/media?parent=6631");
  final response = await http.get(url, headers: {"Accept": "application/json"});

  var convertedDatatoJson = jsonDecode(response.body);
  if (kDebugMode) {
    logger.log("fetchWpVenue => $convertedDatatoJson");
  }
  return convertedDatatoJson;
}

Future<List?> fetchWpDetailVenue() async {
  final Uri url =
      Uri.parse("https://dispora.di-mep.com/wp-json/wp/v2/pages?_embed");
  final response = await http.get(url, headers: {"Accept": "application/json"});

  var convertedDatatoJson = jsonDecode(response.body);
  if (kDebugMode) {
    logger.log("fetchWpVenue => $convertedDatatoJson");
  }
  return convertedDatatoJson;
}

Future<List?> fetchWpMedia() async {
  final Uri url = Uri.parse("https://dispora.di-mep.com/wp-json/wp/v2/media");
  final response = await http.get(url, headers: {"Accept": "application/json"});

  var convertedDatatoJson = jsonDecode(response.body);
  if (kDebugMode) {
    logger.log("fetchWpMedia => $convertedDatatoJson");
  }
  return convertedDatatoJson;
}

Future fetchWpPostCategory(String href) async {
  final Uri url = Uri.parse(href);
  final response = await http.get(url, headers: {"Accept": "application/json"});

  var convertedDatatoJson = jsonDecode(response.body);

  return convertedDatatoJson;
}

Future fetchWpCategory() async {
  final Uri url =
      Uri.parse("https://dispora.di-mep.com/wp-json/wp/v2/categories?_embed");
  final response = await http.get(url, headers: {"Accept": "application/json"});

  var convertedDatatoJson = jsonDecode(response.body);

  return convertedDatatoJson;
}
