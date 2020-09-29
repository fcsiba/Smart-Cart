import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/missionfeed.dart';
import 'package:trash_troopers/screens/organization/mission_feed.dart';
import 'package:trash_troopers/services/mission_api.dart';
import 'package:trash_troopers/widgets/authButton.dart';

import 'mission_toops_details.dart';

class MissionDetails extends StatefulWidget {
  final Mission mission;
  MissionDetails({Key key, this.mission}) : super(key: key);

  @override
  _MissionDetailsState createState() => _MissionDetailsState();
}

class _MissionDetailsState extends State<MissionDetails> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    Mission myMission = this.widget.mission;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "${this.widget.mission.missionName} Control",
        ), // Create Mission
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              // Mission Stepper
              Container(
                child: Stepper(
                  currentStep: _currentStep,
                  onStepTapped: (int step) =>
                      setState(() => _currentStep = step),
                  onStepContinue: _currentStep < 2
                      ? () {
                          setState(() {
                            _currentStep += 1;
                          });
                          if (_currentStep == 2) {
                            // showCompletedPopup(context);
                          }
                          myMission.status = _currentStep;
                          MissionApi().updateMissionByName(
                              myMission, myMission.missionID);

                          // Notify Feed
                          notifyFeed(_currentStep, myMission);
                        }
                      : null,
                  onStepCancel: _currentStep > 0
                      ? () {
                          setState(() {
                            _currentStep -= 1;
                          });
                          myMission.status = _currentStep;
                          MissionApi().updateMissionByName(
                              myMission, myMission.missionID);

                          // Notify Feed
                          notifyFeed(_currentStep, myMission);
                        }
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
                      isActive: _currentStep == 0,
                    ),
                    Step(
                      title: Text(
                        "MISSION IN PROGRESS",
                        style: TextStyle(color: Colors.amber),
                      ),
                      subtitle: Text("Troops have gathered"),
                      content: Text("Hustle up! We can do this!"),
                      isActive: _currentStep == 1,
                    ),
                    Step(
                      title: Text(
                        "MISSION SUCCESSFUL",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      subtitle: Text("The mission was a success."),
                      content: Text("Troops have been disbanded."),
                      isActive: _currentStep == 2,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              AuthButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    // push user here
                    MaterialPageRoute(
                      builder: (context) =>
                          MissionToopsDetails(mission: this.widget.mission),
                    ),
                  );
                },
                label: "Manage Troopers",
                width: 200,
              ),

              SizedBox(
                height: 10,
              ),

              // Check Feed
              AuthButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    // push user here
                    MaterialPageRoute(
                      builder: (context) =>
                          OrgMissionFeed(mission: this.widget.mission),
                    ),
                  );
                },
                label: "Check Mission Feed",
                width: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void notifyFeed(int state, Mission myMission) async {
    if (myMission.leader == null) return;
    MissionFeed myFeed = MissionFeed();
    myFeed.dateTime = DateTime.now();
    myFeed.user = myMission.leader;
    String log = "STATE UPDATE: " + getMessage(state);
    myFeed.description = log;
    print(log);
    MissionApi().addMissionFeed(myMission, myFeed);
  }

  String getMessage(int state) {
    switch (state) {
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
        return "MISSION STATE 404";
        break;
    }
  }
}
