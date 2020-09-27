import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/screens/ratings/ratingtile.dart';
import 'package:trash_troopers/services/user_api.dart';

class Rating extends StatefulWidget {
  Rating({Key key, this.mission}) : super(key: key);

  final Mission mission;

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
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
                                user: userSnapshot.data as User);
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
              // TODO(Sualeh): Check this, should it do something?
              onPressed: () => {Navigator.of(context).pop()},
              icon: Icon(
                Icons.done,
                color: Colors.white,
              ),
              label: Text(
                "I\'m Done",
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
