import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trash_troopers/models/contribution.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/screens/ratings/ratingtile.dart';
import 'package:trash_troopers/services/mission_api.dart';
import 'package:trash_troopers/services/user_api.dart';

class Rating extends StatefulWidget {
  Rating({Key key, this.mission, this.user, this.userTime}) : super(key: key);

  final Mission mission;
  final User user;
  final int userTime;
  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  Map<User, double> myRatings = HashMap<User, double>();

  callback(User user, double rating) {
    print({user.toJson(): rating});
    setState(() {
      this.myRatings.addAll({user: rating});
    });
  }

  // Future<User> getUser() async {
  //   return await UserApi(uid: this.widget.userUID).getUserData();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 400,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0)),
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              "Rate your comrades!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            Expanded(
              child: Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  padding: const EdgeInsets.all(6.0),
                  itemCount: widget.mission.troops.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder(
                        future: UserApi(uid: widget.mission.troops[index].uid)
                            .getUserData(),
                        builder: (context, userSnapshot) {
                          if ((userSnapshot.connectionState ==
                                  ConnectionState.none &&
                              userSnapshot.hasData == null)) {
                            return Center(child: Text('Error!'));
                          } else if (userSnapshot.hasData) {
                            return RatingTile(
                                mission: widget.mission,
                                user: userSnapshot.data as User,
                                callback: callback);
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                            );
                          }
                        });
                  },
                ),
              ),
            ),
            RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0)),
              color: Colors.amber,
              onPressed: () {
                User user = this.widget.user;
                Mission tempMission = this.widget.mission;

                if (tempMission.contributions == null)
                  tempMission.contributions = new HashMap<User, Contribution>();

                Contribution contribution = Contribution(
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                  hasCompleted: true,
                );

                contribution.points = 100;
                // contribution.ratings = this.myRatings;

                // contribution.ratings.forEach((key, value) {
                //   print(key.toJson());
                //   print(value);
                // });

                tempMission.contributions
                    .putIfAbsent(user.uid, () => contribution.toJson());

                MissionApi().updateMissionByName(
                    tempMission, this.widget.mission.missionID);

                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
              label: Text(
                "CLAIM REWARD",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ]),
    );
  }
}
