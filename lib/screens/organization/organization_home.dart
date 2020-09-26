import 'package:flutter/material.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/screens/home/NavPages/MyMissions.dart';

import 'mission_home.dart';

class OrganizationHome extends StatefulWidget {
  final User user;
  OrganizationHome({Key key, this.user}) : super(key: key);
  @override
  _OrganizationHomeState createState() => _OrganizationHomeState();
}

class _OrganizationHomeState extends State<OrganizationHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${this.widget.user.name} Command Center!",
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              CustomButton(
                  label: 'MISSIONS',
                  icon: Icons.map,
                  onPressed: () {
                    // Create a Mission Home
                    Navigator.push(
                      context,
                      // push user here
                      MaterialPageRoute(
                          builder: (context) =>
                              MyOrgMissions(user: this.widget.user)),
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                  label: 'REWARDS', icon: Icons.redeem, onPressed: () {}),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                  label: 'USERS', icon: Icons.people, onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton({@required this.onPressed, this.label, this.icon});
  final GestureTapCallback onPressed;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: 150,
        width: 150,
        child: RaisedButton(
          onPressed: onPressed,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff27AE60), Color(0xff27AE60)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8.0)),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 44,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    label,
                    // textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
