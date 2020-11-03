import 'dart:collection';
import 'package:trash_troopers/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'contribution.g.dart';

@JsonSerializable()
class Contribution {
  DateTime startTime;
  DateTime endTime;
  bool hasCompleted;
  Map ratings = HashMap<User, double>();
  double points;

  Contribution( { this.startTime, this.endTime, this.hasCompleted });

  factory Contribution.fromJson(Map<String, dynamic> json) => _$ContributionFromJson(json);

  Map<String, dynamic> toJson() => _$ContributionToJson(this);
}