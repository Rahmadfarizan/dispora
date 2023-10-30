import 'dart:convert';
import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SosialServiceApi {
  Future<List?> fetchKomunitas() async {
    final Uri url = Uri.parse(
        "https://dispora.pekanbaru.go.id/wp-json/wp/v2/pages?per_page=100&parent=0&_embed");
    try {
      final response =
          await http.get(url, headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (kDebugMode) {
          logger.log("fetchKomunitas => $data");
        }
        return data;
      } else {
        throw Exception('Failed to fetchKomunitas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetchKomunitas: $e');
    }
  }

  Future fetchKomunitasImage(String link) async {
    final Uri url = Uri.parse("$link&_embed");
    try {
      final response =
          await http.get(url, headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        var convertedDatatoJson = jsonDecode(response.body);
        return convertedDatatoJson;
      } else {
        throw Exception(
            'Failed to fetchKomunitasImage: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetchKomunitasImage: $e');
    }
  }
}
