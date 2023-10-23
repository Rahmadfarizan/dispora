import 'package:dispora/service/service_api.dart';

class VenueModel {
  Future<List?> fetchVenueData(String link) async {
    // Replace this with actual data fetching logic
    return await fetchWpVenue(link);
  }

  Future<List?> fetchDetailVenueData(String link) async {
    // Replace this with actual data fetching logic
    return await fetchWpDetailVenue(link);
  }
}
