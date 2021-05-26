import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:touroll/models/place.dart';
import 'package:touroll/utils/constant.dart';

class PlaceService {
  Future<List<Place>> getPlaces(String query) async {
    final key = MapApiKey;
    final response = await http.get(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$key');
    final obj = jsonDecode(response.body);
    Iterable results = obj['results'];
    // print(results);
    return results.map((a) => Place.fromJson(a)).toList();
  }

  Future<Place> coordinatesToPlace(List<double> coordinates) async {
    final key = MapApiKey;
    String lat = coordinates[0].toString();
    String lng = coordinates[1].toString();
    final response = await http.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$key');
    final obj = jsonDecode(response.body);
    Iterable results = obj['results'];
    if (results.length == 0) return null;
    return Place.fromJson(results.elementAt(0));
  }
}
