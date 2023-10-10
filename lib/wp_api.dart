import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List?> fetchWpPosts() async {
  final Uri url = Uri.parse("https://dispora.di-mep.com/wp-json/wp/v2/posts");
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
