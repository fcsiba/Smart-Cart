// Show all missions of this user.
// Mission Detail page - edit delete
// Add new mission fab
// View Users - delete

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/screens/mission/missionform.dart';
import 'package:trash_troopers/services/mission_api.dart';

import 'mission_details.dart';

class MyOrgMissions extends StatefulWidget {
  final User user;
  const MyOrgMissions({Key key, this.user}) : super(key: key);

  @override
  _MyOrgMissionsState createState() => _MyOrgMissionsState();
}

class _MyOrgMissionsState extends State<MyOrgMissions> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Mission> missions;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!

          // Get lat long input
          double lat;
          double lng;

          showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text("Enter Location"),
              content: Container(
                height: 200,
                child: new Column(
                  children: [
                    new TextField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        labelText: 'Latitude',
                      ),
                      onChanged: (value) {
                        lat = double.parse(value);
                      },
                    ),
                    new TextField(
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: new InputDecoration(
                        labelText: 'Longitude',
                      ),
                      onChanged: (value) {
                        lng = double.parse(value);
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('CLOSE'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('NEXT'),
                  onPressed: () {
                    if (lat != null && lng != null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => MissionForm(
                          location: LatLng(lat, lng),
                          oldMission: null,
                          editMode: false,
                        ),
                      ).then((value) => () {
                            Navigator.of(context).pop();
                          });
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      appBar: AppBar(
        title: Text(
          "${this.widget.user.name} Missions",
        ),
        // Create Mission
      ),
      body: StreamBuilder(
          stream: MissionApi().fetchMissionsAsStreamByLeader(this.widget.user),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: Text('No Organization Missions.'));
            // else if (snapshot.data.length < 1)
            //   return Center(child: Text('No Organization Missions.'));
            else {
              missions = (snapshot.data as List<Mission>);
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return missionCard(
                      context,
                      missions[index],
                      () {
                        print('edit');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => MissionForm(
                            location: LatLng(missions[index].latitude,
                                missions[index].longitude),
                            oldMission: missions[index],
                            editMode: true,
                          ),
                        );
                        return;
                      },
                      () {
                        print('delete');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Delete"),
                              content: Text(
                                  "Are you sure to delete ${missions[index].missionName}?"),
                              actions: [
                                FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: () {},
                                ),
                                FlatButton(
                                  child: Text("DELETE"),
                                  onPressed: () {
                                    MissionApi()
                                        .removeMission(missions[index].docID);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  });
            }
          }),
    );
  }

  Widget missionCard(BuildContext context, Mission mission,
      Function onPressedEdit, Function onPressedDelete) {
    // User user = Provider.of<User>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 210,
        child: InkWell(
          onTap: () {
            // GOTO Mission detail page
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MissionDetails(
                          mission: mission,
                        )));
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            elevation: 0.8,
            margin: EdgeInsets.all(0),
            child: Row(
              children: <Widget>[
                // Image Section
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.all(0),
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
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

                // Text Section
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black45,
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
                        // Mission details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.details,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                mission.details,
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

                        SizedBox(height: 10),

                        ButtonBar(
                          alignment: MainAxisAlignment.end,
                          buttonHeight: 30,
                          children: <Widget>[
                            OutlineButton(
                              child: Text(
                                'EDIT',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: onPressedEdit,
                            ),
                            FlatButton(
                                child: Text('DELETE'),
                                color: Colors.red,
                                onPressed: onPressedDelete),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
