import 'package:json_annotation/json_annotation.dart';
part 'point.g.dart';

@JsonSerializable()
class Point {
  final String type;
  final List<double> coordinates;
  Point({this.type, this.coordinates});

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);
  Map<String, dynamic> toJson() => _$PointToJson(this);
}
