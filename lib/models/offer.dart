import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';

part 'offer.g.dart';

@JsonSerializable()
class Offer {
  final String id;
  String name;
  String detail;
  String vendor;
  String offerCode;
  String image;
  String type;
  int points;
  final Timestamp createdAt;
  Timestamp updatedAt;

  Offer({
    @required this.id,
    @required this.name,
    @required this.detail,
    @required this.vendor,
    @required this.offerCode,
    @required this.image,
    @required this.type,
    @required this.points,
    @required this.createdAt,
    @required this.updatedAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
