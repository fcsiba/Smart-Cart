import 'dart:io';
import 'dart:math';

import "package:flutter/material.dart";
import 'package:confetti/confetti.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:provider/provider.dart';

import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/missionfeed.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/screens/mission/feedbox.dart';
import 'package:trash_troopers/screens/ratings/rating.dart';
import 'package:trash_troopers/services/mission_api.dart';
import 'package:trash_troopers/services/missionfeed_api.dart';
import 'package:trash_troopers/services/user_api.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class MissionDetailPage extends StatefulWidget {
  MissionDetailPage({Key key, this.currentMission}) : super(key: key);

  final Mission currentMission;

  @override
  _MissionDetailState createState() => _MissionDetailState();
}

class _MissionDetailState extends State<MissionDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final descController = TextEditingController();
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  int _currentStep = 0;
  File _image;
  String _uploadedFileUrl;
  bool fileUploading = false;
  List<MissionFeed> missionFeedList;
  MissionFeedApi missionFeedApi = MissionFeedApi();
  Mission myMission;
  User myUser = User();
  BeautifulPopup popup;

  void showMessage(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(message)));
  }

  @override
  void initState() {
    _controllerCenterRight = ConfettiController(duration: Duration(seconds: 2));
    _controllerCenterLeft = ConfettiController(duration: Duration(seconds: 2));

    if (widget.currentMission != null) {
      myMission = widget.currentMission;
    }

    popup = BeautifulPopup(
      context: context,
      template: TemplateGift,
    );
    // final newColor = Theme.of(context).primaryColor.withOpacity(1);
    // popup.recolor(newColor);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myUser = Provider.of<User>(context);
    // TODO: Join Karnay pe test User jara hai..
    // if (myUser.name == null) {
    //   myUser.name = "Test User";
    // }

    _currentStep = myMission.status;
    // var missionList = Provider.of<List<Mission>>(context);
    // print(missionList?.length);
    // missionFeedList?.forEach((f) => {
    //     print(f.description)
    // });
    return Scaffold(
      key: _scaffoldKey,
      // bottomNavigationBar: BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      // ),
      resizeToAvoidBottomPadding: false,
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text("Add Story"),
      //   onPressed: () => {generateForm(context)},
      //   isExtended: true,
      //   backgroundColor: Colors.orangeAccent,
      //   icon: Icon(Icons.add_to_photos),
      // ),
      appBar: AppBar(
        title: Text(
          "${myMission.missionName}!",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //CENTER RIGHT -- Emit left
            Align(
              alignment: Alignment.topRight,
              child: ConfettiWidget(
                confettiController: _controllerCenterRight,
                blastDirection: pi / 2, // radial value - LEFT
                emissionFrequency: 0.6,
                numberOfParticles: 10,
                shouldLoop: false,
                colors: [
                  Colors.green,
                  Colors.blue,
                  Colors.pink
                ], // manually specify the colors to be used
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ConfettiWidget(
                confettiController: _controllerCenterLeft,
                blastDirection: pi / 2, // radial value - RIGHT
                emissionFrequency: 0.6,
                numberOfParticles: 10,
              ),
            ),
            /*  Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text("LIVE",
                          style: TextStyle(
                              letterSpacing: 5.5,
                              fontSize: 11,
                              color: Colors.white)),
                      decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(18.0)),
                          color: Colors.red),
                    ),
                    Text(" Mission Feed 🚨",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ), */
            FutureBuilder(
                future: UserApi(uid: myUser.uid).getUserData(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.none &&
                      userSnapshot.hasData == null) {
                    return Center(child: Text('Error!'));
                  } else if (userSnapshot.hasData) {
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
                }),
            Container(
              child: Stepper(
                currentStep: _currentStep,
                // onStepTapped: (int step) => setState(() => _currentStep = step),
                onStepContinue: _currentStep < 2
                    ? () => {
                          setState(() {
                            _currentStep += 1;
                            if (_currentStep == 2) {
                              _controllerCenterLeft.play();
                              _controllerCenterRight.play();
                              showCompletedPopup(context);
                            }
                            myMission.status = _currentStep;
                            MissionApi().updateMissionByName(
                                myMission, myMission.missionID);
                          })
                        }
                    : null,
                onStepCancel: _currentStep > 0
                    ? () => setState(() {
                          _currentStep -= 1;
                          myMission.status = _currentStep;
                          MissionApi().updateMissionByName(
                              myMission, myMission.missionID);
                        })
                    : null,
                steps: [
                  Step(
                    title: Text(
                      "MISSION INITIATED",
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                    subtitle: Text("Mission is starting.."),
                    content: Text(
                        "The Mission is about to start. Rally the troops!"),
                  ),
                  Step(
                    title: Text(
                      "MISSION IN PROGRESS",
                      style: TextStyle(color: Colors.amber),
                    ),
                    subtitle: Text("Troops have gathered"),
                    content: Text("Hustle up! We can do this!"),
                  ),
                  Step(
                    title: Text(
                      "MISSION SUCCESSFUL",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Text("Troops have disbanded"),
                    content: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text("The mission was a success."),
                        RaisedButton(
                          onPressed: () => {
                            // Rating Sheet
                            _scaffoldKey.currentState.showBottomSheet(
                                (context) => Rating(mission: myMission))
                          },
                          color: Theme.of(context).primaryColor,
                          child: Text("RATE YOUR COMRADES",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
