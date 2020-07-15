import 'package:trash_troopers/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'missionfeed.g.dart';

@JsonSerializable()
class MissionFeed {
  String description;
  User user;
  DateTime dateTime;

  MissionFeed( {this.description, this.user, this.dateTime} );

  factory MissionFeed.fromJson(Map<String, dynamic> json) => _$MissionFeedFromJson(json);

  Map<String, dynamic> toJson() => _$MissionFeedToJson(this);
}