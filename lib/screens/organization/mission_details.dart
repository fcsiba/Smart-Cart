import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/mission_api.dart';

class MissionDetails extends StatefulWidget {
  final Mission mission;
  MissionDetails({Key key, this.mission}) : super(key: key);

  @override
  _MissionDetailsState createState() => _MissionDetailsState();
}

class _MissionDetailsState extends State<MissionDetails> {
  @override
  Widget build(BuildContext context) {
    final List<User> troops = this.widget.mission.troops;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${this.widget.mission.missionName} Troopers",
        ),
        // Create Mission
      ),
      body: troops.isEmpty ? Center(child: Text("No Troopers")) :ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: troops.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                margin: EdgeInsets.all(0.0),
                child: ListTile(
                  // User profile image
                  leading: ClipOval(
                      child: SizedBox(
                    height: 40,
                    width: 40,
                    child: troops[index].profilePhoto == null
                        ? Image.asset(
                            'assets/images/defaultProfilePicture.png',
                            fit: BoxFit.fill,
                            color: Colors.lightGreen[900],
                          )
                        : CachedNetworkImage(
                            imageUrl: troops[index].profilePhoto,
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                                new CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                  )),
                  // Name
                  title: Text(
                    '${troops[index].name}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),

                  // email
                  subtitle: Text(
                    '${troops[index].email}',
                    style: Theme.of(context).textTheme.caption,
                  ),

                  // Delete trooper
                  trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Mission tempMission = this.widget.mission;
                        tempMission.troops.removeWhere((t) => t.email == troops[index].email);
                        // To update mission
                        MissionApi().updateMissionByName(tempMission, tempMission.missionID);
                      }),
                ),
              ),
            );
          }),
    );
  }
}