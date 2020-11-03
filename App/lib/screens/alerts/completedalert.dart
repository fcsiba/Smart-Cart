import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompletedAlert {
  static AlertDialog showAlert(BuildContext context) {
      var alert =  AlertDialog(
      title: const  Align(alignment: Alignment.center,
                    child:Text("Congratulations!", style: TextStyle(color: Colors.purpleAccent, fontFamily: "Sofia", fontWeight: FontWeight.bold, fontSize: 38))),
      content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           Align(alignment: Alignment.center,child: Text("🎖",style: TextStyle(fontSize: 50))),
          Align(alignment: Alignment.center,child: Text("Salute to you fellow Trash Trooper! We have awarded you for your efforts. Keep on contributing so we can ")),
          Align(alignment: Alignment.center,child: Text("#MakePakistanGreenAgain",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
          ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Roger!'),

        ),
      ],

    );
    return alert;
  }
}