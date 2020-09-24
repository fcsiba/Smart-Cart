import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:trash_troopers/models/contribution.dart';
import 'package:trash_troopers/models/missionfeed.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:flutter/foundation.dart';

// flutter pub run build_runner build --delete-conflicting-outputs
part 'mission.g.dart';

enum MissionStatus { Initiated, InProgresss, Aborted, Successful }

@JsonSerializable()
class Mission {
  final String missionID;
  String missionName;
  User leader;
  List<User> troops = [];
  List<MissionFeed> feed = [];
  Map contributions = new HashMap<User, Contribution>();
  int status;
  String details;
  String address;
  double longitude;
  double latitude;
  String siteImage;
  int expectedCapacity;
  int dangerLevel;
  String docID;
  final Timestamp createdAt;
  Timestamp updatedAt;

  // int missionStatusNumber() {
  //     switch (this.status) {
  //     case MissionStatus.Initiated: {
  //        return 0;
  //     }
  //     break;
  //     case MissionStatus.InProgresss: {
  //        return 1;
  //     }
  //     break;
  //     case MissionStatus.Successful: {
  //        return 2;
  //     }
  //     break;
  //     default: {
  //       return -1;
  //     }
  // }
  // }

  bool hasUser(User user) {
    bool flag = false;
    this.troops.forEach((troop) {
      if (troop.uid == user.uid) flag = true;
    });
    return flag;
  }

  bool isLeader(User user) {
    bool flag = false;
    if (this.leader.uid == user.uid) flag = true;
    return flag;
  }

  void progress() {
    switch (this.status) {
      case 0:
        {
          this.status = 1;
        }
        break;
      case 1:
        {
          this.status = 2;
        }
        break;
      default:
        {}
    }
  }

  void regress() {
    switch (this.status) {
      case 2:
        {
          this.status = 1;
        }
        break;
      case 1:
        {
          this.status = 0;
        }
        break;
      default:
        {}
    }
  }

  static List encondeTroopsToJson(List<User> list) {
    List jsonList = List();
    list.map((item) {
      jsonList.add(item.toJson());
    }).toList();
    return jsonList;
  }

  Mission({
    @required this.missionID,
    @required this.missionName,
    this.details,
    this.address,
    @required this.longitude,
    @required this.latitude,
    @required this.siteImage,
    @required this.expectedCapacity,
    @required this.dangerLevel,
    this.leader,
    this.troops,
    this.feed,
    this.contributions,
    this.status,
    this.docID,
    @required this.createdAt,
    @required this.updatedAt,
  });

  // Create getters and setters.

  void calculatePoints() {
    int ctr = 0;
    double totalPoints = 0;
    contributions.forEach((user, c) {
      ctr = 0;
      totalPoints = 0.0;
      contributions.forEach((user2, c) {
        if (user.name != user2.name && c.ratings.containsKey(user)) {
          ctr++;
          totalPoints += c.ratings[user];
        }
      });
      c.points = totalPoints / ctr;
    });
  }

  factory Mission.fromJson(Map<String, dynamic> json) =>
      _$MissionFromJson(json);

  Map<String, dynamic> toJson() => _$MissionToJson(this);
}
