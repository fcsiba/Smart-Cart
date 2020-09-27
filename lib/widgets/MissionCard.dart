import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/screens/mission/missiondetail.dart';

class MissionCard extends StatelessWidget {
  MissionCard({
    Key key,
    this.mission,
    this.onTapped,
    this.onPressed,
    this.member,
  }) : super(key: key);

  final Mission mission;
  final Function onTapped;
  final Function onPressed;
  final bool member;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 6.0,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                  child: Center(
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: mission.siteImage,
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // missionName
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.map,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            mission.missionName,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).primaryColor,
                            ),
                            maxLines: 1,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Mission address
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.place,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            mission.address,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Troop count and Danger Level
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Troop Count
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.group,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${mission.troops.length}/${mission.expectedCapacity}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),

                        // Danger Level
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: mission.dangerLevel < 3
                                  ? Theme.of(context).primaryColor
                                  : mission.dangerLevel == 3
                                      ? Colors.orangeAccent
                                      : Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${mission.dangerLevel}/${5}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Button Bar
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      buttonHeight: 30,
                      children: <Widget>[
                        // Disable unless joined
                        this.member
                            ? OutlineButton(
                                child: Text(
                                  'VIEW',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MissionDetailPage(
                                                  currentMission: mission)));
                                },
                              )
                            : SizedBox(),

                        this.member
                            ? FlatButton(
                                child: Text('LEAVE'),
                                color: Theme.of(context).primaryColor,
                                onPressed: onPressed)
                            : FlatButton(
                                child: Text('JOIN'),
                                color: Theme.of(context).primaryColor,
                                onPressed: onPressed),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
