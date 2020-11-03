import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  AuthButton({@required this.onPressed, this.label, this.width});
  final GestureTapCallback onPressed;
  final String label;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 50,
        child: RaisedButton(
          onPressed: onPressed,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff27AE60),Color(0xff27AE60)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(40.0)),
            child: Container(
              constraints: BoxConstraints(maxWidth: width, minHeight: 50),
              alignment: Alignment.center,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
