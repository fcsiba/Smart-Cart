import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:trash_troopers/models/user.dart';

class UserApi {
  final String uid;
  UserApi({
    @required this.uid,
  });

  // Creating Account
  // Collection refrence
  final CollectionReference userData = Firestore.instance.collection('users');

  Future setUserData(
      String email, String password, String name, String profilePhoto, String userType) async {
    return await userData.document(uid).setData({
      "uid":uid,
      "email": email,
      "password": password,
      "name": name,
      "profilePhoto": profilePhoto,
      "userType": userType,
    });
  }

  Future updateUserDataProfilePicture(String profilePhoto) async {
    return await userData.document(uid).updateData({
      "profilePhoto": profilePhoto,
    });
  }

  Future userExists() async {
    DocumentSnapshot documentSnapshot = await userData.document(uid).get();
    return documentSnapshot.data == null ? false : true;
  }

  Future<User> getUserData() async {
    DocumentSnapshot documentSnapshot = await userData.document(uid).get();
    if (documentSnapshot.data != null) {
      User user = User.fromJson(documentSnapshot.data);
      user.uid = uid;
      return user;
    }
    return Future.error("No Record Found");
  }

  Stream<User> fetchUserAsStream() {
    return userData.document(uid).snapshots().map((x) => User.fromJson(x.data));
  }
}
