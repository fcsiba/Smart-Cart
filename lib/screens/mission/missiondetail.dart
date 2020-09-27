import "package:flutter/material.dart";
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_timer/flutter_timer.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/missionfeed.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/screens/mission/feedbox.dart';
import 'package:trash_troopers/screens/ratings/rating.dart';
import 'package:trash_troopers/services/mission_api.dart';
import 'package:trash_troopers/services/missionfeed_api.dart';
import 'package:trash_troopers/services/user_api.dart';
import 'package:trash_troopers/widgets/authButton.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class MissionDetailPage extends StatefulWidget {
  MissionDetailPage({Key key, this.currentMission}) : super(key: key);

  final Mission currentMission;

  @override
  _MissionDetailState createState() => _MissionDetailState();
}

class _MissionDetailState extends State<MissionDetailPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final descController = TextEditingController();
  int _currentStep = 0;
  bool fileUploading = false;
  List<MissionFeed> missionFeedList;
  MissionFeedApi missionFeedApi = MissionFeedApi();

  Mission myMission;
  User myUser = User();
  User user;
  BeautifulPopup popup;

  bool running = false;
  bool processed = false;
  int myMinutes = 0;
  bool hide = false;

  void showMessage(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }

  @override
  void get initState {
    if (widget.currentMission != null) {
      myMission = widget.currentMission;
    }

    popup = BeautifulPopup(
      context: context,
      template: TemplateGift,
    );
    // final newColor = Theme.of(context).primaryColor.withOpacity(1);
    // popup.recolor(newColor);

    super.initState;
  }

  @override
  Widget build(BuildContext context) {
    myUser = Provider.of<User>(context);
    _currentStep = myMission.status;

    // var missionList = Provider.of<List<Mission>>(context);
    // print(missionList?.length);
    // missionFeedList?.forEach((f) => {
    //     print(f.description)
    // });

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Welcome to Mission ${myMission.missionName}",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'STATUS: ' + getMissionStatus(myMission.status),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),

            // Contribution Timer
            myMission.status == 1
                ? Center(
                    child: TikTikTimer(
                      initialDate: DateTime.now(),
                      running: running,
                      height: 40,
                      width: 100,
                      backgroundColor: Colors.transparent,
                      timerTextStyle:
                          TextStyle(color: Colors.green, fontSize: 26),
                      isRaised: false,
                      tracetime: (time) {
                        myMinutes = time.getCurrentMinute;
                      },
                    ),
                  )
                : SizedBox(),

            // Mission FeedBox
            FutureBuilder(
              future: UserApi(uid: myUser.uid).getUserData(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.none &&
                    userSnapshot.hasData == null) {
                  return Center(child: Text('Error!'));
                } else if (userSnapshot.hasData) {
                  this.user = userSnapshot.data as User;
                  return FeedBox(
                      mission: myMission, user: userSnapshot.data as User);
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }
              },
            ),

            // Mission Details Body
            Container(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        '${myMission.missionName} Mission Details',
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Details: ${myMission.details}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Address: ${myMission.address}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Leader: ${myMission.leader.name}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Joined Toopers: ${myMission.troops.length}',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Updated At: ' +
                              new DateFormat.yMd()
                                  .add_jm()
                                  .format(myMission.updatedAt.toDate()),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cash me outside
            myMission.status == 1
                ? !hide
                    ? AuthButton(
                        width: 200,
                        label: running ? 'END MY MISSION' : 'START MY MISSION',
                        onPressed: () {
                          try {
                            if (running == false && processed == false) {
                              setState(() {
                                running = true;
                                processed = true;
                              });
                            } else if (running == true && processed == true) {
                              setState(() {
                                running = false;
                                hide = true;
                              });

                              _scaffoldKey.currentState
                                  .showBottomSheet((context) => Rating(
                                        mission: myMission,
                                        userTime: myMinutes,
                                        user: this.user,
                                      ));
                            }

                            // Send a message on the feed
                            notifyFeed(user);

                          } catch (e) {
                            print('error here');
                          }
                        },
                      )
                    : SizedBox()
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void notifyFeed(User user) async {
    if (user.uid == null) return;
    // user = await UserApi(uid: user.uid).getUserData();

    MissionFeed myFeed = MissionFeed();
    myFeed.dateTime = DateTime.now();
    myFeed.user = user;
    String log = running
        ? 'START MY MISSION...'
        : 'END MY MISSION. Total Minutes: $myMinutes';
    myFeed.description = log;
    MissionApi().addMissionFeed(myMission, myFeed);
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Rating();
        });
  }

  void showCompletedPopup(BuildContext context) {
    popup.show(
      title: 'Congratulations!',
      content: Column(children: <Widget>[
        Align(
            alignment: Alignment.center,
            child: Text(
                "Salute to you fellow Trash Trooper! We have awarded you for your efforts. Keep on contributing so we can ")),
        SizedBox(
          height: 20,
        ),
        Align(
            alignment: Alignment.center,
            child: Text("#MakePakistanGreenAgain",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
      ]),
      actions: [
        popup.button(
          label: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      ],
      // bool barrierDismissible = false,
      // Widget close,
    );
  }
}

String getMissionStatus(int status) {
  switch (status) {
    case 0:
      return "MISSION INITIATED";
      break;
    case 1:
      return "MISSION IN PROGRESS";
      break;
    case 2:
      return "MISSION SUCCESSFUL";
      break;
    default:
      return "404";
      break;
  }
}
