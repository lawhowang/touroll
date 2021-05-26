// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tour _$TourFromJson(Map<String, dynamic> json) {
  return Tour(
    id: json['id'] as int,
    organizerId: json['organizerId'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    coverImage: json['coverImage'] as String,
    price: json['price'] as int,
    days: json['days'] as int,
    startDate: json['startDate'] == null
        ? null
        : DateTime.parse(json['startDate'] as String),
    endDate: json['endDate'] == null
        ? null
        : DateTime.parse(json['endDate'] as String),
    location: json['location'] == null
        ? null
        : Point.fromJson(json['location'] as Map<String, dynamic>),
    published: json['published'] as bool,
    views: json['views'] as int,
    activities: (json['activities'] as List)
        ?.map((e) =>
            e == null ? null : Activity.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    organizer: json['organizer'] == null
        ? null
        : User.fromJson(json['organizer'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TourToJson(Tour instance) => <String, dynamic>{
      'id': instance.id,
      'organizerId': instance.organizerId,
      'title': instance.title,
      'description': instance.description,
      'coverImage': instance.coverImage,
      'price': instance.price,
      'days': instance.days,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'location': instance.location,
      'published': instance.published,
      'views': instance.views,
      'activities': instance.activities,
      'organizer': instance.organizer,
    };
