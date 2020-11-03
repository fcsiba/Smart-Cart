import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/foundation.dart';
part 'offer.g.dart';

@JsonSerializable()
class Offer {
  final String id;
  String docID;
  String creatorId;
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
    this.docID,
    @required this.creatorId,
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

  
  bool isCreator(String uid) {
    bool flag = false;
    if (this.creatorId == uid) flag = true;
    return flag;
  }

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
