import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/missionfeed.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/mission_api.dart';

class FeedBox extends StatefulWidget {
  FeedBox({Key key, this.user, this.mission}) : super(key: key);

  final User user;
  final Mission mission;

  @override
  _FeedBoxState createState() => _FeedBoxState();
}

class _FeedBoxState extends State<FeedBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height / 2.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Insert Feed
            TextField(
              maxLength: 120,
              maxLines: 1,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.live_help),
                suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      // Insert text to firebase in mission->missionFeed
                    }),
                filled: true,
                fillColor: Colors.white60,
                labelText: 'What\'s happening??',
                border: InputBorder.none,
              ),
            ),

            // Show feed
            Container(
              height: (MediaQuery.of(context).size.height / 2.8) / 1.5,
              // color: Colors.indigo,
              child: StreamBuilder<List<MissionFeed>>(
                  stream:
                      MissionApi().fetchMissionFeedsAsStream(widget.mission),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) 
                    return ListView.builder(
                      // reverse: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Card(
                            margin: EdgeInsets.all(0.0),
                            child: 
                            
                            ListTile(
                              // User profile image
                              leading: Icon(Icons.person),

                              // Message
                              title: Text(
                                '${snapshot.data[index].description}.',
                                style: Theme.of(context).textTheme.body2,
                              ),

                              // Sender
                              subtitle: Text(
                                '${snapshot.data[index].user.name}',
                                style: Theme.of(context).textTheme.caption,
                              ),

                              // Message sent time
                              trailing: Text(
                                new DateFormat.jm()
                                    .format(snapshot.data[index].dateTime),
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    else {
                      return Column(
                        children: <Widget>[
                          SpinKitThreeBounce(
                            color: Colors.greenAccent,
                          ),
                          Text("Fetching data..")
                        ],
                      );
                    }
                  }),
            )
          ],
        ));
  }
}
