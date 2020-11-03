// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mission _$MissionFromJson(Map<String, dynamic> json) {
  return Mission(
    missionID: json['missionID'] as String,
    missionName: json['missionName'] as String,
    details: json['details'] as String,
    address: json['address'] as String,
    docID: json['docID'] as String,
    longitude: (json['longitude'] as num)?.toDouble(),
    latitude: (json['latitude'] as num)?.toDouble(),
    siteImage: json['siteImage'] as String,
    expectedCapacity: json['expectedCapacity'] as int,
    dangerLevel: json['dangerLevel'] as int,
    leader: json['leader'] == null
        ? null
        : User.fromJson(json['leader'] as Map<dynamic, dynamic>),
    troops: (json['troops'] as List)
        ?.map((e) => e == null ? null : User.fromJson(e))
        ?.toList(),
    feed: (json['feed'] as List)
        ?.map((e) =>
            e == null ? null : MissionFeed.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    contributions: json['contributions'] as Map<String, dynamic>,
    status: json['status'] as int,
    createdAt: json['createdAt'] as Timestamp,
    updatedAt: json['updatedAt'] as Timestamp,
  );
}

Map<String, dynamic> _$MissionToJson(Mission instance) {
  return <String, dynamic>{
    'missionID': instance.missionID,
    'docID': instance.docID,
    'missionName': instance.missionName,
    'leader': instance.leader?.toJson(),
    'troops': instance.troops.map((u) {
      return u.toJson();
    }).toList(),
    'feed': instance.feed,
    'contributions': instance.contributions,
    'status': instance.status,
    'details': instance.details,
    'address': instance.address,
    'longitude': instance.longitude,
    'latitude': instance.latitude,
    'siteImage': instance.siteImage,
    'expectedCapacity': instance.expectedCapacity,
    'dangerLevel': instance.dangerLevel,
    'createdAt': instance.createdAt,
    'updatedAt': instance.updatedAt,
  };
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$MissionStatusEnumMap = {
  MissionStatus.Initiated: 'Initiated',
  MissionStatus.InProgresss: 'InProgresss',
  MissionStatus.Aborted: 'Aborted',
  MissionStatus.Successful: 'Successful',
};
