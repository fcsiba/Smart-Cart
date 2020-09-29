import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/missionfeed.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/mission_api.dart';

class FeedBox extends StatefulWidget {
  FeedBox({Key key, this.mission, this.user, this.maxHeight}) : super(key: key);
  final bool maxHeight;
  final Mission mission;
  final User user;

  @override
  _FeedBoxState createState() => _FeedBoxState();
}

class _FeedBoxState extends State<FeedBox> {
  final myController = TextEditingController();

  Mission _mission;
  User _user;
  ScrollController _scrollController;

  @override
  void get initState {
    _mission = widget.mission;
    _user = widget.user;
    _scrollController = new ScrollController();
    super.initState;
  }

  void submit() {
    MissionFeed myFeed = MissionFeed();
    myFeed.dateTime = DateTime.now();
    myFeed.user = _user;
    myFeed.description = myController.value.text;
    MissionApi().addMissionFeed(_mission, myFeed);
    myController.text = '';
    _scrollController.animateTo(0,
        duration: new Duration(seconds: 1), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green,
        padding: EdgeInsets.all(5),
        height: this.widget.maxHeight
            ? MediaQuery.of(context).size.height
            : MediaQuery.of(context).size.height / 3.1,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // Insert Feed
              TextField(
                textInputAction: TextInputAction.done,
                onSubmitted: (v) {
                  submit();
                },
                controller: myController,
                maxLines: 1,
                decoration: InputDecoration(
                  // Clear on sbmit
                  prefixIcon: Icon(Icons.message, color: Colors.green),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send, color: Colors.green),
                    onPressed: () {
                      submit();
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'What\'s happening?',
                  labelStyle: TextStyle(color: Colors.green),
                  border: InputBorder.none,
                ),
              ),
              // Show feed
              StreamBuilder<List<MissionFeed>>(
                  stream: MissionApi().fetchMissionFeedsAsStream(_mission),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0) {
                      return Container(
                        height: this.widget.maxHeight
                            ? MediaQuery.of(context).size.height / 1.5
                            : (MediaQuery.of(context).size.height / 3.1) / 1.35,
                        // color: Colors.indigo,

                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          controller: _scrollController,
                          reverse: this.widget.maxHeight ? false : true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            MissionFeed currentFeed = snapshot.data[index];

                            return Card(
                              margin: EdgeInsets.all(0.0),
                              child: ListTile(
                                // User profile image
                                leading: ClipOval(
                                    child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: currentFeed.user.profilePhoto == null
                                      ? Image.asset(
                                          'assets/images/defaultProfilePicture.png',
                                          fit: BoxFit.fill,
                                          color: Colors.lightGreen[900],
                                        )
                                      : CachedNetworkImage(
                                          imageUrl:
                                              currentFeed.user.profilePhoto,
                                          fit: BoxFit.fill,
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        ),
                                )),
                                // Message
                                title: Text(
                                  '${currentFeed.description}',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),

                                // Sender
                                subtitle: Text(
                                  currentFeed.user != null
                                      ? '${currentFeed.user?.name}'
                                      : 'Sample User',
                                  style: Theme.of(context).textTheme.caption,
                                ),

                                // Message sent time
                                trailing: Text(
                                  new DateFormat.jm()
                                      .format(currentFeed.dateTime),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(height: 50),
                          SpinKitDoubleBounce(
                            size: 30,
                            color: Colors.white,
                          ),
                          SizedBox(height: 30),
                          Text(
                            "Fetching live feed..",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      );
                    }
                  })
            ],
          ),
        ));
  }
}
