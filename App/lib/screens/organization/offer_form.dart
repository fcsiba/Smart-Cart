import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:trash_troopers/models/offer.dart';
import 'package:trash_troopers/models/user.dart';
import 'package:trash_troopers/services/helper.dart';
import 'package:trash_troopers/services/offer_api.dart';
import 'package:trash_troopers/services/user_api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OfferForm extends StatefulWidget {
  final Offer oldOffer;
  final bool editMode;

  @override
  _OfferFormState createState() => _OfferFormState();

  OfferForm({
    Key key,
    this.oldOffer,
    this.editMode,
  }) : super(key: key);
}

class _OfferFormState extends State<OfferForm> {
  final _formKey = GlobalKey<FormState>();

  File _image;
  String _uploadedFileUrl;

  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  final vendorController = TextEditingController();
  final pointsController = TextEditingController();
  final codeController = TextEditingController();
  final typeController = TextEditingController();

  final namefocus = FocusNode();
  final detailsfocus = FocusNode();
  final vendorfocus = FocusNode();
  final pointsfocus = FocusNode();
  final codefocus = FocusNode();
  final typefocus = FocusNode();

  var fillColor = Colors.white;

  User currentUser;

  bool _autoValidate = false;
  bool isUploading = false;

  String _dummyImage =
      "https://firebasestorage.googleapis.com/v0/b/trash-troopers.appspot.com/o/offers%2Ftopup.jpg?alt=media&token=d29bb764-75c5-4e1f-a8cf-36a3e3f61ee5";

  void submitForm() {
    String _offerID = Helper.generateHash(16);
    Offer offerTemp = Offer(
      id: _offerID,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      vendor: vendorController.text.titleCase,
      detail: detailsController.text.sentenceCase,
      name: nameController.text.titleCase,
      points: int.parse(pointsController.text),
      offerCode: codeController.text,
      type: typeController.text,
      image: _uploadedFileUrl ?? _dummyImage,
      creatorId: currentUser.uid,
    );

    OfferApi().addOffer(offerTemp);
  }

  void updateForm() {
    Offer offerUpdated = Offer(
      id: this.widget.oldOffer.id,
      createdAt: this.widget.oldOffer.createdAt,
      updatedAt: Timestamp.now(),
      vendor: vendorController.text.titleCase,
      detail: detailsController.text.sentenceCase,
      name: nameController.text.titleCase,
      points: int.parse(pointsController.text),
      offerCode: codeController.text,
      type: typeController.text,
      image: _uploadedFileUrl ?? _dummyImage,
      creatorId: this.widget.oldOffer.creatorId,
      docID: this.widget.oldOffer.docID,
    );
    OfferApi().updateOfferByID(offerUpdated, this.widget.oldOffer.id);
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
      nameController.text = this.widget.oldOffer.name;
      detailsController.text = this.widget.oldOffer.detail;
      vendorController.text = this.widget.oldOffer.vendor;
      codeController.text = this.widget.oldOffer.offerCode;
      pointsController.text = this.widget.oldOffer.points.toString();
      typeController.text = this.widget.oldOffer.type;

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
                      this.widget.editMode ? 'Update Offer' : 'Create Offer',
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
                                  updateForm();
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
                                      'Select Image',
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

                            // offer Name
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: namefocus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(detailsfocus);
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
                                labelText: 'Offer Name',
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
                            // Detail
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: detailsfocus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(vendorfocus);
                              },
                              validator: (value) => validate(value),
                              controller: detailsController,
                              decoration: InputDecoration(
                                helperMaxLines: 2,
                                prefixIcon: Icon(
                                  Icons.details,
                                  color: Theme.of(context).primaryColor,
                                ),
                                filled: true,
                                fillColor: fillColor,
                                labelText: 'Offer Details',
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
                              height: 10,
                            ),

                            // Vendor
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              focusNode: vendorfocus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context)
                                    .requestFocus(pointsfocus);
                              },
                              validator: (value) => validate(value),
                              controller: vendorController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.info,
                                  color: Theme.of(context).primaryColor,
                                ),
                                filled: true,
                                fillColor: fillColor,
                                labelText: 'Vendor Name',
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
                              height: 15,
                            ),

                            // Points
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              focusNode: pointsfocus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(typefocus);
                              },
                              validator: (value) => validate(value),
                              controller: pointsController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.info,
                                  color: Theme.of(context).primaryColor,
                                ),
                                filled: true,
                                fillColor: fillColor,
                                labelText: 'Points',
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
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                            ),

                            SizedBox(
                              height: 15,
                            ),

                            // Type
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              focusNode: typefocus,
                              onFieldSubmitted: (v) {
                                FocusScope.of(context).requestFocus(codefocus);
                              },
                              validator: (value) => validate(value),
                              controller: typeController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.info,
                                  color: Theme.of(context).primaryColor,
                                ),
                                filled: true,
                                fillColor: fillColor,
                                labelText: 'Offer Type',
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
                              height: 15,
                            ),

                            // Offercode
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              focusNode: codefocus,
                              onFieldSubmitted: (v) {
                                codefocus.unfocus();
                              },
                              validator: (value) => validate(value),
                              controller: codeController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.info,
                                  color: Theme.of(context).primaryColor,
                                ),
                                filled: true,
                                fillColor: fillColor,
                                labelText: 'Offer Code',
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
                              height: 15,
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
        FirebaseStorage.instance.ref().child('offers/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    _uploadedFileUrl = await taskSnapshot.ref.getDownloadURL();
    setState(() {
      isUploading = false;
    });
  }
}
