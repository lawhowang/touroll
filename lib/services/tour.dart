import 'package:flutter/foundation.dart';
import 'package:touroll/models/activity.dart';
import 'package:touroll/models/point.dart';
import 'package:touroll/models/reservation.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/utils/http.dart';

class TourService {
  Future<Tour> getTour(int id, [List<String> expand]) async {
    final res = await HttpUtils.getData('tours/$id', {'expand': expand});
    return Tour.fromJson(res);
  }

  Future<List<Tour>> getMostViewedTours() async {
    Iterable tours = await HttpUtils.getData('tours/most-viewed');
    return tours.map((t) => Tour.fromJson(t)).toList();
  }

  Future<List<Tour>> getNearbyTours(double lat, double lon,
      {int after,
      int limit = 10,
      bool desc = false,
      String orderBy = 'startDate'
    }) async {
    Iterable tours =
        await HttpUtils.getData('tours/nearby', {'lat': '$lat', 'lon': '$lon', 'after': after, 'limit': limit, 'orderBy': orderBy, 'desc': desc});
    return tours.map((t) => Tour.fromJson(t)).toList();
  }

  Future<List<Tour>> searchTours(String query,
      {int after,
      int limit = 10,
      bool desc = false,
      String orderBy = 'startDate'}) async {
    Iterable tours = await HttpUtils.getData('tours/search', {
      'query': query,
      'after': after,
      'limit': limit,
      'orderBy': orderBy,
      'desc': desc,
    });
    return tours.map((t) => Tour.fromJson(t)).toList();
  }

  Future<List<Activity>> getTourActivities(int tourId) async {
    Iterable activities = await HttpUtils.getData('tours/$tourId/activities');
    return activities.map((a) => Activity.fromJson(a)).toList();
  }

  Future<List<Reservation>> getTourReservations(int tourId) async {
    Iterable reservations =
        await HttpUtils.getData('tours/$tourId/reservations');
    return reservations.map((a) => Reservation.fromJson(a)).toList();
  }

  //
  Future<Tour> createTour(
      {@required String title,
      @required String description,
      @required bool published,
      @required DateTime startDate,
      @required DateTime endDate,
      @required int days,
      @required int price,
      String coverImage,
      Point location}) async {
    final createdTour = await HttpUtils.postData('tours', {
      'title': title,
      'description': description,
      'published': published,
      'startDate': startDate.toString().substring(0, 10),
      'endDate': endDate.toString().substring(0, 10),
      'price': price * 100,
      'days': days,
      'coverImage': coverImage,
      'location': location != null ? location.toJson() : null
    });
    return Tour.fromJson(createdTour);
  }

  Future<Tour> updateTour(int id,
      {String title,
      String description,
      bool published,
      DateTime startDate,
      DateTime endDate,
      int days,
      int price,
      String coverImage,
      Point location}) async {
    final updatedTour = await HttpUtils.patchData('tours/$id', {
      'title': title,
      'description': description,
      'published': published,
      'startDate': startDate.toString().substring(0, 10),
      'endDate': endDate.toString().substring(0, 10),
      'days': days,
      'price': price * 100,
      'coverImage': coverImage,
      'location': location != null ? location.toJson() : null
    });
    return Tour.fromJson(updatedTour);
  }

  Future<bool> deleteTour(int id) async {
    await HttpUtils.deleteData('tours/$id');
    return true;
  }
}
