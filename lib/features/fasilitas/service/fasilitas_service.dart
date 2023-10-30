import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as logger show log;

import '../model/fasilitas_model.dart';

// Future<List?> fetchWpVenue(String link) async {
//   // final Uri url = Uri.parse(
//   //     "https://dispora.pekanbaru.go.id/wp-json/wp/v2/media?parent=6631");
//   final Uri url = Uri.parse(link);
//   try {
//     final response =
//         await http.get(url, headers: {"Accept": "application/json"});

//     if (response.statusCode == 200) {
//       var convertedDatatoJson = jsonDecode(response.body);
//       if (kDebugMode) {
//         //logger.log("fetchWpVenue => $convertedDatatoJson");
//       }
//       return convertedDatatoJson;
//     } else {
//       throw Exception('Failed to load venue: ${response.statusCode}');
//     }
//   } catch (e) {
//     throw Exception('Failed to load venue: $e');
//   }
// }
class FasilitasServiceApi {
  Future<dynamic> fetchVenueData(String link) async {
    final Uri url = Uri.parse(link);
    try {
      final response =
          await http.get(url, headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        logger.log("fetchVenueData => $data");
        return data;
      } else {
        throw Exception('Failed to load venue: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load venue: $e');
    }
  }

  Future<List?> fetchDetailVenue() async {
    // final Uri url =
    //     Uri.parse("https://dispora.pekanbaru.go.id/wp-json/wp/v2/pages?_embed");

    final Uri url = Uri.parse(
        "https://dispora.pekanbaru.go.id/wp-json/wp/v2/pages?per_page=100&parent=0&_embed");
    try {
      final response =
          await http.get(url, headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        if (kDebugMode) {
          logger.log("fetchDetailVenue => $data");
        }
        return data;
      } else {
        throw Exception('Failed to load venue detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load venue detail: $e');
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
}
