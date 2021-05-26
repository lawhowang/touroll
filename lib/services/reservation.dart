import 'package:flutter/foundation.dart';
import 'package:touroll/models/reservation.dart';
import 'package:touroll/utils/http.dart';

class ReservationService {
  Future<Reservation> getReservation(int id, [List<String> expand]) async {
    final reservation = await HttpUtils.getData('reservations/$id', expand != null ?? {
      'expand': expand.join(',')
    });
    return Reservation.fromJson(reservation);
  }
  
  Future<Reservation> createReservation({
    @required DateTime startDate,
    @required DateTime endDate,
    @required int tourId
  }) async {
    final start = startDate.toString().substring(0, 10);
    final end = endDate.toString().substring(0, 10);
    final reservation = await HttpUtils.postData('reservations', {
      'startDate': start,
      'endDate': end,
      'tourId': tourId
    });
    return Reservation.fromJson(reservation);
  }
}