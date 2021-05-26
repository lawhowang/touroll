// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return Activity(
    id: json['id'] as int,
    tourId: json['tourId'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    image: json['image'] as String,
    time: json['time'] as int,
    duration: json['duration'] as int,
    location: json['location'] == null
        ? null
        : Point.fromJson(json['location'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'tourId': instance.tourId,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
      'time': instance.time,
      'duration': instance.duration,
      'location': instance.location,
    };
