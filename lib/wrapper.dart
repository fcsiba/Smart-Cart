import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/screens/auth/authPage.dart';
import 'package:trash_troopers/screens/home/home.dart';
import 'package:trash_troopers/services/auth_api.dart';
import 'package:trash_troopers/services/user_api.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: AuthApi().user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return !snapshot.hasData
              ? AuthPage()
              : FutureBuilder(
                  // On new user, data dyrn mein ata hai so future builder has completed. remove this.
                  future: UserApi(uid: snapshot.data.uid).getUserData(),
                  builder: (context, userSnapshot) {
                    // check if connection.active then user.hasData thing..
                    if (userSnapshot.hasData) {
                      return Home(user: userSnapshot.data as User);
                    } else if (userSnapshot.hasData == null &&
                        userSnapshot.connectionState == ConnectionState.none) {
                      return Center(child: Text('User Data Not Found!'));
                    } else {
                      return Scaffold(
                        body: Center(
                          child: SpinKitThreeBounce(
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      );
                    }
                  },
                );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
          );
        }
      },
    );
  }
}
