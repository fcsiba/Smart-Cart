import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/missionfeed.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/auth_api.dart';
import 'package:trash_troopers/services/mission_api.dart';
import 'package:trash_troopers/services/missionfeed_api.dart';
import 'package:trash_troopers/wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<int, Color> primaryColorMap = {
      900: Color.fromRGBO(39, 174, 96, 1),
    };
    Map<int, Color> primaryColorLightMap = {
      900: Color.fromRGBO(75, 215, 134, 1),
    };
    Map<int, Color> primaryColorDarkMap = {
      900: Color.fromRGBO(0, 104, 55, 1),
    };
    return MultiProvider(
        providers: [
          StreamProvider<User>.value(value: AuthApi().user),
          StreamProvider<List<Mission>>.value(
              value: MissionApi().fetchMissionsAsStream()),
          StreamProvider<List<MissionFeed>>.value(
              value: MissionFeedApi().fetchMissionFeedsAsStream()),
        ],
        child: MaterialApp(
          title: 'Trash Troopers',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: MaterialColor(0xff27AE60, primaryColorMap),
            primaryColorDark: MaterialColor(0xff006837, primaryColorDarkMap),
            primaryColorLight: MaterialColor(0xff4bd786, primaryColorLightMap),
            accentColor: Colors.green,
            backgroundColor: Colors.white,
          ),
          home: SafeArea(
            child: Wrapper(),
          ),
        ));
  }
}
