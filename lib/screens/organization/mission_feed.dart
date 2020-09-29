import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/screens/mission/feedbox.dart';

class OrgMissionFeed extends StatefulWidget {
  final Mission mission;
  OrgMissionFeed({Key key, this.mission}) : super(key: key);

  @override
  _OrgMissionFeedState createState() => _OrgMissionFeedState();
}

class _OrgMissionFeedState extends State<OrgMissionFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${this.widget.mission.missionName} Feed",
        ), // Create Mission
      ),
      body: FeedBox(
          mission: this.widget.mission, user: this.widget.mission.leader, maxHeight: true),
    );
  }
}
