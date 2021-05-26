import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String email;
  final String name;
  final String icon;
  final String about;
  final String firebaseUid;

  User({this.id, this.email, this.name, this.icon, this.about, this.firebaseUid});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
