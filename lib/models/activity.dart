import 'package:json_annotation/json_annotation.dart';
import 'package:touroll/models/point.dart';
part 'activity.g.dart';

@JsonSerializable()
class Activity {
  final int id;
  final int tourId;
  final String title;
  final String description;
  final String image;
  final int time;
  final int duration;
  final Point location;

  Activity({
    this.id,
    this.tourId,
    this.title,
    this.description,
    this.image,
    this.time,
    this.duration,
    this.location
  });

  factory Activity.fromJson(Map<String,dynamic> json) => _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
