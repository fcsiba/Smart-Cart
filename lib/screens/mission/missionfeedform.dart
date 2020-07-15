import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MissionFeedForm extends StatefulWidget {
  @override
  _MissionFeedFormState createState() => _MissionFeedFormState();
}

class _MissionFeedFormState extends State<MissionFeedForm> {

  String photo;
  String content;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return 
      Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
              TextFormField()
        ]
     )
    
    );
  }
}