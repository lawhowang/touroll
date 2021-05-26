import 'package:json_annotation/json_annotation.dart';
part 'upload.g.dart';

@JsonSerializable()
class Upload {
  final String uploadURL;

  Upload({this.uploadURL});

  factory Upload.fromJson(Map<String, dynamic> json) => _$UploadFromJson(json);
  Map<String, dynamic> toJson() => _$UploadToJson(this);
}
