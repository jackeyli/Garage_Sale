import 'package:geocoder/geocoder.dart';
Future<Coordinates> findGeoLocation(String query) async {
  // Attempt to get the currently authenticated user
  var addresses = await Geocoder.local.findAddressesFromQuery(query);
  var first = addresses.first;
  return first.coordinates;
}