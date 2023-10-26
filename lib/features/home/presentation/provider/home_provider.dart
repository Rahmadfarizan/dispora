import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../model/home_model.dart';
import '../../service/home_service.dart';

class HomeProvider extends ChangeNotifier {
  final _apiService = HomeServiceApi();
  List<Berita> _berita = [];
  bool _isLoading = false;

  List<Berita> get berita => _berita;

  Future<List<Berita>> loadBerita(int categoryPost) async {
    try {
      _berita.clear();
      _isLoading = true;
      final responseData = await _apiService.fetchPosts(categoryPost);
      if (responseData == null) {
        _berita = [];
        _isLoading = false;
      } else {
        final List listData = responseData;

        for (var i = 0; i < listData.length; i++) {
          _berita.add(Berita.fromJson(listData[i]));
        }
        _isLoading = false;
      }
      notifyListeners();
      return _berita;
    } catch (e) {
      if (kDebugMode) {
        logger.log('FatalException-loadBerita: $e');
      }
      throw 'Terjadi kesalahan saat mengambil data. \nMohon coba kembali nanti.';
    }
  }
}
