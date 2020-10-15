import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trash_troopers/models/mission.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/helper.dart';
import 'package:trash_troopers/services/mission_api.dart';
import 'package:trash_troopers/services/user_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MissionForm extends StatefulWidget {
  final LatLng location;
  final Mission oldMission;
  final bool editMode;
  
  @override
  _MissionFormState createState() => _MissionFormState();
  
  MissionForm({
    Key key,
    this.location,
    this.oldMission,
    this.editMode,
  }) : super(key: key);
}

class _MissionFormState extends State<MissionForm> {
  final _formKey = GlobalKey<FormState>();

  File _image;
  String _uploadedFileUrl;

  final detailsController = TextEditingController();
  final addressController = TextEditingController();
  final nameController = TextEditingController();

  final namefocus = FocusNode();
  final addressfocus = FocusNode();
  final detailsfocus = FocusNode();

  var fillColor = Colors.white;

  int requiredTroops = 1;
  int trashLevel = 1;
  User currentUser;

  bool _autoValidate = false;
  bool isUploading = false;

  String _dummyImage =
      "https://firebasestorage.googleapis.com/v0/b/trash-troopers.appspot.com/o/photos%2Fsolidwaste_sample-min.jpg?alt=media&token=35dbfd43-78a8-48ee-bc02-2cf060be2005";

  void submitForm() {
    String _missionID = Helper.generateHash(16);
    MissionApi().addMission(Mission(
      missionID: _missionID,
      missionName: nameController.text.titleCase,
      address: addressController.text.titleCase,
      details: detailsController.text.sentenceCase,
      latitude: widget.location.latitude,
      longitude: widget.location.longitude,
      troops: [],
      siteImage: _uploadedFileUrl ?? _dummyImage,
      dangerLevel: trashLevel,
      status: 0,
      expectedCapacity: requiredTroops,
      leader: currentUser,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    ));
  }

  String validate(String value) {
    if (value.trim().isEmpty) {
      return "Can not leave blank!";
    } else {
      return null;
    }
  }

  bool onInit = true;

  @override
  Widget build(BuildContext context) {
    final userID = Provider.of<User>(context).uid;

    if (this.widget.editMode && onInit) {
      nameController.text = this.widget.oldMission.missionName;
      addressController.text = this.widget.oldMission.address;
      detailsController.text = this.widget.oldMission.details;
      trashLevel = this.widget.oldMission.dangerLevel;
      requiredTroops = this.widget.oldMission.expectedCapacity;
      onInit = false;
    }
    
    return FutureBuilder(
      future: UserApi(uid: userID).getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return Center(child: Text('Error!'));
        } else if (snapshot.hasData) {
          currentUser = snapshot.data as User;

          return AbsorbPointer(
            absorbing: isUploading,
            child: isUploading
                ? Center(
                    child: SpinKitThreeBounce(
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    title: Text(
                      this.widget.editMode
                          ? 'Update Mission'
                          : 'Create Mission',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    actions: <Widget>[
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                          FlatButton(
                            child: this.widget.editMode
                                ? Text('UPDATE')
                                : Text('CREATE'),
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await uploadPic(context);
                                // update if edit mode
                                if (this.widget.editMode) {
                                  // update mission
                                  Mission updatedMission = Mission(
                                    missionID: this.widget.oldMission.missionID,
                                    missionName: nameController.text.titleCase,
                                    address: addressController.text.titleCase,
                                    details:
                                        detailsController.text.sentenceCase,
                                    latitude: widget.location.latitude,
                                    longitude: widget.location.longitude,
                                    troops: this.widget.oldMission.troops,
                                    siteImage: _uploadedFileUrl ?? _dummyImage,
                                    dangerLevel: trashLevel,
                                    status: this.widget.oldMission.status,
                                    expectedCapacity: requiredTroops,
                                    leader: this.widget.oldMission.leader,
                                    createdAt: this.widget.oldMission.createdAt,
                                    updatedAt: Timestamp.now(),
                                  );

                                  MissionApi().updateMissionByName(
                                      updatedMission,
                                      this.widget.oldMission.missionID);
                                } else {
                                  submitForm();
                                }
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                    content: Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ButtonTheme(
                                  height: 50.0,
                                  child: OutlineButton(
                                    child: Text(
                                      'Take a Picture',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    onPressed: () {
                                      chooseFile();
                                    },
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: new SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: (_image != null)
                                          ? Image.file(
                                              _image,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/logo.png',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            // Mission Name
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: namefocus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(addressfocus);
                              },
                              validator: (value) => validate(value),
                              controller: nameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.map,
                                  color: Theme.of(context).primaryColor,
                                ),
                                filled: true,
                                fillColor: fillColor,
                                labelText: 'Mission Name',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            // Address
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: addressfocus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(detailsfocus);
                              },
                              validator: (value) => validate(value),
                              controller: addressController,
                              decoration: InputDecoration(
                                helperMaxLines: 2,
                                helperText:
                                    'Coordinates: (${widget.location.latitude.toStringAsFixed(5)}, ${widget.location.longitude.toStringAsFixed(5)})',
                                prefixIcon: Icon(
                                  Icons.place,
                                  color: Theme.of(context).primaryColor,
                                ),
                                filled: true,
                                fillColor: fillColor,
                                labelText: 'Mission Address',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            // Mission Details
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              focusNode: detailsfocus,
                              onFieldSubmitted: (v) {
                                detailsfocus.unfocus();
                              },
                              validator: (value) => validate(value),
                              controller: detailsController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.info,
                                  color: Theme.of(context).primaryColor,
                                ),
                                filled: true,
                                fillColor: fillColor,
                                labelText: 'Mission Details',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0)),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              maxLines: 2,
                            ),

                            SizedBox(
                              height: 15,
                            ),

                            // Troop Capacity
                            Text('Required Troopers',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black54,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RawMaterialButton(
                                  onPressed: requiredTroops > 1
                                      ? () {
                                          setState(() {
                                            requiredTroops--;
                                          });
                                        }
                                      : null,
                                  child: new Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  shape: new CircleBorder(),
                                  fillColor: Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.all(5.0),
                                ),
                                SizedBox(
                                  child: Text(
                                    '$requiredTroops',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  width: 20,
                                ),
                                RawMaterialButton(
                                  onPressed: requiredTroops < 10
                                      ? () {
                                          setState(() {
                                            requiredTroops++;
                                          });
                                        }
                                      : null,
                                  child: new Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  shape: new CircleBorder(),
                                  fillColor: Theme.of(context).primaryColor,
                                  padding: const EdgeInsets.all(5.0),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 15,
                            ),

                            Text('Danger Level',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black54,
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            RatingBar(
                              initialRating: 1,
                              minRating: 1,
                              maxRating: 5,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, index) {
                                switch (trashLevel) {
                                  case 5:
                                    return Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    );
                                  case 4:
                                    return Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    );
                                  case 3:
                                    return Icon(
                                      Icons.delete,
                                      color: Colors.amber,
                                    );
                                  case 2:
                                    return Icon(
                                      Icons.delete,
                                      color: Colors.lightGreen,
                                    );
                                  case 1:
                                    return Icon(
                                      Icons.delete,
                                      color: Theme.of(context).primaryColor,
                                    );
                                }
                              },
                              onRatingUpdate: (rating) {
                                setState(() {
                                  trashLevel = rating.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        } else {
          return Center(
            child: SpinKitThreeBounce(
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(
            // maxHeight: 480, maxWidth: 640 compresses image
            source: ImageSource.camera,
            maxHeight: 480,
            maxWidth: 640)
        .then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadPic(BuildContext context) async {
    setState(() {
      isUploading = true;
    });
    if (_image == null) {
      return null;
    }
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('missions/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    _uploadedFileUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      isUploading = false;
    });
  }
}
