import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/mission_api.dart';

class RatingTile extends StatefulWidget {
  RatingTile({Key key, this.mission, this.user}) : super(key: key);
  final double rating = 0.0;
  final Mission mission;
  final User user;
  @override
  _RatingTileState createState() => _RatingTileState();
}

class _RatingTileState extends State<RatingTile> {



  @override
  Widget build(BuildContext context) {
    User currUser = Provider.of<User>(context);

    return Card(
        elevation: 4.0,
        color: Theme.of(context).primaryColorDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          leading: Container(
            width: 60,
            padding: EdgeInsets.only(right: 6.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 2.0, color: Colors.white24))),
            child: Stack(
              children: <Widget>[
                Container(
                  child: ClipOval(
                    child: Center(
                      child: CachedNetworkImage(
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.profilePhoto,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage('assets/images/military-badge.png'),
                    color: Colors.amber,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            widget.user.name,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RatingBar(
                initialRating: 3,
                minRating: 1,
                maxRating: 5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  MissionApi().addMissionRating(widget.mission, currUser.uid, widget.user.uid, rating);
                },
              )
            ],
          ),
          // trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
        ));
  }
}
