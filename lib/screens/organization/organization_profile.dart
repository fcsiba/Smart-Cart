import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trash_troopers/screens/home/NavPages/Profile.dart';

class MyOrgProfile extends StatefulWidget {
  MyOrgProfile({Key key}) : super(key: key);

  @override
  _MyOrgProfileState createState() => _MyOrgProfileState();
}

class _MyOrgProfileState extends State<MyOrgProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Company Profile",
        ),
      ),
      body: Container(
        child: Profile(
          isOrganization: true,
        ),
      ),
    );
  }
}
