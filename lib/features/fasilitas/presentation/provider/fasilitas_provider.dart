import 'dart:developer' as logger show log;

import 'package:flutter/foundation.dart';

import '../../model/fasilitas_model.dart';
import '../../service/fasilitas_service.dart';

class FasilitasProvider extends ChangeNotifier {
  final _apiService = FasilitasServiceApi();
  List<Fasilitas> _venues = [];
  List<FasilitasDetail> _venuesDetail = [];
  List<FasilitasList> _venuesList = [];
  bool _isLoading = false;

  List<Fasilitas> get venues => _venues;
  List<FasilitasDetail> get venuesDetail => _venuesDetail;
  List<FasilitasList> get venuesList => _venuesList;

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
      final responseData = await _apiService.fetchDetailVenue();
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

  Future<List<FasilitasList>> loadListFasilitas(String kecamatan) async {
    try {
      kecamatan =
          (kecamatan == "Bina widya") ? kecamatan = "Bina Widya" : kecamatan;
      _venuesList.clear();
      _isLoading = true;
      final responseData = await _apiService.fetchFasilitasList();
      if (responseData == null) {
        _venuesList = [];
        _isLoading = false;
      } else {
        final List listData = responseData;

        for (var i = 0; i < listData.length; i++) {
          if (kecamatan == "Rumbai") {
            if (listData[i]['title']["rendered"].contains(kecamatan) &&
                !listData[i]['title']["rendered"].contains("Rumbai Barat")) {
              _venuesList.add(FasilitasList.fromJson(listData[i]));
            }
          } else {
            if (listData[i]['title']["rendered"].contains(kecamatan)) {
              _venuesList.add(FasilitasList.fromJson(listData[i]));
            }
          }
        }
        logger.log("loadListFasilitas $kecamatan => $_venuesList");
        _isLoading = false;
      }
      notifyListeners();
      return _venuesList;
    } catch (e) {
      if (kDebugMode) {
        logger.log('FatalException-loadListFasilitas: $e');
      }
      throw 'Terjadi kesalahan saat mengambil data. \nMohon coba kembali nanti.';
    }
  }
}
