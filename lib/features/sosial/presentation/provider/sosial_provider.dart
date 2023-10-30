import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../../fasilitas/model/fasilitas_model.dart';
import '../../model/sosial_model.dart';
import '../../service/sosial_service.dart';

class SosialProvider extends ChangeNotifier {
  final _apiService = SosialServiceApi();
  List<Sosial> _komunitas = [];
  List<SosialDetail> _komunitasDetail = [];
  bool _isLoading = false;

  List<Sosial> get komunitas => _komunitas;
  List<SosialDetail> get komunitasDetail => _komunitasDetail;
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
          if (listData[i]["slug"].contains("komunitas-olahraga")) {
            _komunitas.add(Sosial.fromJson(listData[i]));
            // loadKomunitasImage(
            //     listData[i]["_links"]["wp:attachment"][0]["href"]);
          }
        }
        logger.log("loadKomunitas => $_komunitas");
        _isLoading = false;
      }
      notifyListeners();
      return _komunitas;
    } catch (e) {
      if (kDebugMode) {
        logger.log('FatalException-loadKomunitas: $e');
      }
      throw 'Terjadi kesalahan saat mengambil data. \nMohon coba kembali nanti.';
    }
  }

  Future<List<SosialDetail>> loadKomunitasImage(String link) async {
    try {
      _komunitasDetail.clear();
      _isLoading = true;
      final responseData = await _apiService.fetchKomunitasImage(link);
      if (responseData == null) {
        _komunitasDetail = [];
        _isLoading = false;
      } else {
        final List listData = responseData;

        for (var i = 0; i < listData.length; i++) {
          _komunitasDetail.add(SosialDetail.fromJson(listData[i]));
        }
        logger.log("listDataImagelink => $link");
        logger.log("listDataImage => $listData");
        logger.log("loadKomunitasImage => $_komunitasDetail");
        _isLoading = false;
      }
      notifyListeners();
      return _komunitasDetail;
    } catch (e) {
      if (kDebugMode) {
        logger.log('FatalException-loadKomunitasImage: $e');
      }
      throw 'Terjadi kesalahan saat mengambil data. \nMohon coba kembali nanti.';
    }
  }
}
