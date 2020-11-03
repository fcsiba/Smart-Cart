// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) {
  return Offer(
    id: json['id'] as String,
    docID: json['docID'] as String,
    creatorId: json['creatorId'] as String,
    name: json['name'] as String,
    detail: json['detail'] as String,
    vendor: json['vendor'] as String,
    offerCode: json['offerCode'] as String,
    image: json['image'] as String,
    type: json['type'] as String,
    points: json['points'] as int,
    createdAt: json['createdAt'] as Timestamp,
    updatedAt: json['updatedAt'] as Timestamp,
  );
}

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'id': instance.id,
      'docID': instance.docID,
      'creatorId': instance.creatorId,
      'name': instance.name,
      'detail': instance.detail,
      'vendor': instance.vendor,
      'offerCode': instance.offerCode,
      'image': instance.image,
      'type': instance.type,
      'points': instance.points,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
