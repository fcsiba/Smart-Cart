// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contribution _$ContributionFromJson(Map<String, dynamic> json) {
  return Contribution(
    startTime: json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String),
    endTime: json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String),
    hasCompleted: json['hasCompleted'] as bool,
  )
    ..ratings = json['ratings'] as Map<String, dynamic>
    ..points = (json['points'] as num)?.toDouble();
}

Map<String, dynamic> _$ContributionToJson(Contribution instance) =>
    <String, dynamic>{
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'hasCompleted': instance.hasCompleted,
      'ratings': instance.ratings,
      'points': instance.points,
    };
