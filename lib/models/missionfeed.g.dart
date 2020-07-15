// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missionfeed.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MissionFeed _$MissionFeedFromJson(Map<String, dynamic> json) {
  return MissionFeed(
    description: json['description'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    dateTime: json['dateTime'] == null
        ? null
        : DateTime.parse(json['dateTime'] as String),
  );
}

Map<String, dynamic> _$MissionFeedToJson(MissionFeed instance) =>
    <String, dynamic>{
      'description': instance.description,
      'user': instance.user,
      'dateTime': instance.dateTime?.toIso8601String(),
    };
