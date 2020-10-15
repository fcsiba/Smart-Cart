import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/user_api.dart';
import 'package:trash_troopers/services/auth_api.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String profilePhoto = "";
  File _imageFile;
  String _userID;

  Future getImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (mounted)
      setState(() {
        _imageFile = image;
        profilePhoto = image.path;
      });
    uploadPic(context);
  }

  Future uploadPic(BuildContext context) async {
    // TODO: Add Upload Loader.

    String fileName = basename(_imageFile.path);
    StorageReference firbaseStorageRef =
        FirebaseStorage.instance.ref().child('photos').child(fileName);

    StorageUploadTask uploadTask = firbaseStorageRef.putFile(_imageFile);
    try {
      await uploadTask.onComplete;
      var imageURL = await firbaseStorageRef.getDownloadURL();
      await UserApi(uid: _userID).updateUserDataProfilePicture(imageURL);
    } catch (e) {
      if (mounted)
        setState(() {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Upload Failed"),
          ));
        });
    }
    if (mounted)
      setState(() {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Profile Picture Uploaded"),
        ));
      });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    _userID = Provider.of<User>(context)?.uid;
    return StreamBuilder(
        stream: UserApi(uid: _userID).fetchUserAsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            nameController.value = TextEditingValue(text: snapshot.data.name);
            emailController.value = TextEditingValue(text: snapshot.data.email);

            return Container(
              width: _width,
              height: _height,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Profile Picutre
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: new CircleAvatar(
                              radius: _width / 6,
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: (snapshot.data.profilePhoto !=
                                                null &&
                                            snapshot.data.profilePhoto != '')
                                        ? CachedNetworkImage(
                                            imageUrl:
                                                snapshot.data.profilePhoto,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          )
                                        : Icon(
                                            Icons.person,
                                            color: Colors.green[900],
                                            size: 48,
                                          )),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            bottom: 12.0,
                            child: new RawMaterialButton(
                              onPressed: () {
                                getImage(context);
                              },
                              child: new Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                                size: 20.0,
                              ),
                              shape: new CircleBorder(),
                              elevation: 5.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(10.0),
                            ),
                          )
                        ],
                      ),

                      // Name
                      TextFormField(
                        controller: nameController,
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          filled: true,
                          fillColor: Colors.white70,
                          labelText: 'Name',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide:
                                BorderSide(color: Colors.amberAccent, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide:
                                BorderSide(color: Colors.amberAccent, width: 2),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      // Email
                      TextFormField(
                        controller: emailController,
                        enabled: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                          fillColor: Colors.white70,
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide:
                                BorderSide(color: Colors.amberAccent, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            borderSide:
                                BorderSide(color: Colors.amberAccent, width: 2),
                          ),
                        ),
                      ),

                      // TODO: Add more user details. User Rating, User Points

                      SizedBox(
                        height: 50,
                      ),
                      logoutButton(context),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('No record found.'),
                logoutButton(context),
              ],
            ));
          } else if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget logoutButton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      color: Theme.of(context).primaryColor,
      icon: Icon(
        Icons.exit_to_app,
        color: Colors.white,
      ),
      label: Text(
        'LOGOUT',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () async {
        await AuthApi().signOut();
        Navigator.of(context).pop();
      },
      elevation: 4.0,
    );
  }
}
