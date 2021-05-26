import 'package:json_annotation/json_annotation.dart';
import 'package:touroll/models/activity.dart';
import 'package:touroll/models/point.dart';
import 'package:touroll/models/user.dart';
part 'tour.g.dart';

@JsonSerializable()
class Tour {
  int id;
  int organizerId;
  String title;
  String description;
  String coverImage;
  int price;
  int days;
  DateTime startDate;
  DateTime endDate;
  Point location;
  bool published;
  int views;
  List<Activity> activities;
  User organizer;
  Tour({
    this.id,
    this.organizerId,
    this.title,
    this.description,
    this.coverImage,
    this.price,
    this.days,
    this.startDate,
    this.endDate,
    this.location,
    this.published,
    this.views,
    this.activities,
    this.organizer
  });
  factory Tour.fromJson(Map<String, dynamic> json) {
    json['price'] = (json['price'] / 100).round();
    return _$TourFromJson(json);
  }
  Map<String, dynamic> toJson () {
    this.price = this.price * 100;
    final r = _$TourToJson(this);
    this.price = (this.price / 100).round();
    return r;
  }
}
