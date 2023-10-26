import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../model/fasilitas_model.dart';
import '../../service/fasilitas_service.dart';

class FasilitasProvider extends ChangeNotifier {
  final _apiService = FasilitasServiceApi();
  List<Fasilitas> _venues = [];
  List<FasilitasDetail> _venuesDetail = [];
  bool _isLoading = false;

  List<Fasilitas> get venues => _venues;
  List<FasilitasDetail> get venuesDetail => _venuesDetail;

  Future<List<Fasilitas>> loadFasilitas(String link) async {
    try {
      _venues.clear();
      _isLoading = true;
      final responseData = await _apiService.fetchVenueData(link);
      if (responseData == null) {
        _venues = [];
        _isLoading = false;
      } else {
        final List listData = responseData;

        for (var i = 0; i < listData.length; i++) {
          _venues.add(Fasilitas.fromJson(listData[i]));
        }
        _isLoading = false;
      }
      notifyListeners();
      return _venues;
    } catch (e) {
      if (kDebugMode) {
        logger.log('FatalException-loadFasilitas: $e');
      }
      throw 'Terjadi kesalahan saat mengambil data. \nMohon coba kembali nanti.';
    }
  }

  Future<List<FasilitasDetail>> loadDetailFasilitas(String link) async {
    try {
      _venuesDetail.clear();
      _isLoading = true;
      final responseData = await _apiService.fetchDetailVenue(link);
      if (responseData == null) {
        _venuesDetail = [];
        _isLoading = false;
      } else {
        final List listData = responseData;

        for (var i = 0; i < listData.length; i++) {
          _venuesDetail.add(FasilitasDetail.fromJson(listData[i]));
        }
        logger.log("loadDetailFasilitas => $_venuesDetail");
        _isLoading = false;
      }
      notifyListeners();
      return _venuesDetail;
    } catch (e) {
      if (kDebugMode) {
        logger.log('FatalException-loadDetailFasilitas: $e');
      }
      throw 'Terjadi kesalahan saat mengambil data. \nMohon coba kembali nanti.';
    }
  }
}
