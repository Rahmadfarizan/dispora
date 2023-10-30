import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../fasilitas/model/fasilitas_model.dart';
import '../../model/sosial_model.dart';
import '../../service/sosial_service.dart';

class SosialProvider extends ChangeNotifier {
  final _apiService = SosialServiceApi();
  List<Sosial> _komunitas = [];
  bool _isLoading = false;

  List<Sosial> get komunitas => _komunitas;

  Future<List<Sosial>> loadKomunitas() async {
    try {
      _komunitas.clear();
      _isLoading = true;
      final responseData = await _apiService.fetchKomunitas();
      if (responseData == null) {
        _komunitas = [];
        _isLoading = false;
      } else {
        final List listData = responseData;

        for (var i = 0; i < listData.length; i++) {
          _komunitas.add(Sosial.fromJson(listData[i]));
        }
        logger.log("loadDetailFasilitas => $_komunitas");
        _isLoading = false;
      }
      notifyListeners();
      return _komunitas;
    } catch (e) {
      if (kDebugMode) {
        logger.log('FatalException-loadDetailFasilitas: $e');
      }
      throw 'Terjadi kesalahan saat mengambil data. \nMohon coba kembali nanti.';
    }
  }
}
