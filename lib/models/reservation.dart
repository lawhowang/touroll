
import 'package:json_annotation/json_annotation.dart';
import 'package:touroll/models/tour.dart';
part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int id;
  int userId;
  int tourId;
  Tour tour;
  DateTime startDate;
  DateTime endDate;
  Reservation({
    this.id,
    this.userId,
    this.tourId,
    this.tour,
    this.startDate,
    this.endDate
  });

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}