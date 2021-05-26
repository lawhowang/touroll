import 'package:json_annotation/json_annotation.dart';
import 'package:touroll/models/location.dart';
import 'package:touroll/models/point.dart';
part 'geometry.g.dart';

@JsonSerializable()
class Geometry {
  final Location location;

  Geometry({
    this.location
  });

  factory Geometry.fromJson(Map<String,dynamic> json) => _$GeometryFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}
