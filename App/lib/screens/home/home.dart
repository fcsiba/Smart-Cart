import 'package:flutter/material.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/screens/home/NavPages/OfferStore.dart';

import 'NavPages/MissionFinder.dart';
import 'NavPages/MyMissions.dart';
import 'NavPages/Profile.dart';

class Home extends StatefulWidget {
  final User user;
  const Home({Key key, this.user}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _title;
  int _currentIndex;
  String _name;
  @override
  void get initState {
    super.initState;
    _currentIndex = 1;
    _title = _titles.elementAt(_currentIndex);
    _name = this.widget.user.name == '' || this.widget.user.name == null
        ? 'Profile'
        : this.widget.user.name;
  }

  // Bottom bar pages
  final List<Widget> _children = [
    MyMissions(),
    MissionFinder(),
    OfferStore(),
    // Redeem(),
    Profile(),
  ];

  // Appbar Titles
  final List<String> _titles = [
    'My Missions',
    'Find Missions',
    'Redeem',
    'Profile'
  ];

  void onTabTapped(int index) {
    setState(() {
      _title = _titles.elementAt(index);
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(child: child, opacity: animation);
        },
        child: _children[_currentIndex],
      ),
      appBar: _currentIndex != 2
          ? AppBar(
              title: Text(
                '$_title',
                style: TextStyle(
                  fontFamily: 'QuickSand',
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                _currentIndex != 1
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: IconButton(
                          onPressed: () {},
                          icon: new Icon(
                            Icons.near_me,
                            color: Colors.white,
                          ),
                          tooltip: "Missions Near Me",
                        ),
                      ),
              ],
            )
          : null,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   icon: Icon(Icons.add),
      //   label: Text('Create Mission'),
      //   backgroundColor: Colors.amber,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text(
              'Missions',
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.map),
            title: new Text('Finder'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.redeem),
            title: Text('Redeem'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.person_outline),
            title: new Text(
              '$_name',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
