import 'package:json_annotation/json_annotation.dart';
import 'package:touroll/models/geometry.dart';
import 'package:touroll/models/point.dart';
part 'place.g.dart';

@JsonSerializable()
class Place {
  final String formatted_address;
  final String name;
  final Geometry geometry;

  Place({
    this.formatted_address,
    this.name,
    this.geometry
  });

  factory Place.fromJson(Map<String,dynamic> json) => _$PlaceFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceToJson(this);
}
