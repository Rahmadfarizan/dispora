import 'package:dispora/service/service_api.dart';

class VenueModel {
  Future<List?> fetchVenueData() async {
    // Replace this with actual data fetching logic
    return await fetchWpVenue();
  }

  Future<List?> fetchDetailVenueData() async {
    // Replace this with actual data fetching logic
    return await fetchWpDetailVenue();
  }
}
