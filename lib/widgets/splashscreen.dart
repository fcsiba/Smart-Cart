import 'dart:ui';
import 'package:flutter/material.dart';
// Splashscreen with custom delay.
// HOW TO USE
// final Future<String> _calculation = Future<String>.delayed(
//   Duration(seconds: 300),
//   () => 'sampleText',
// );

// @override
// Widget build(BuildContext context) {
//   return FutureBuilder<String>(
//     future: _calculation,
//     builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//       if (snapshot.hasData) {
//         PUT LOGIC HERE
//       } else {
//         return SplashScreen();
//       }
//     },
//   );
// }

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: _width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Animation placeholder
            // Logo
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    // Fix delay in image load.
                    Image.asset(
                      "assets/images/logo.png",
                      width: _width * 0.6,
                    ),
                    // CircleAvatar(
                    //   backgroundColor: Colors.transparent,
                    //   child: ClipOval(
                    //       child: Container(
                    //     child: FlareActor("assets/animations/earth.flr",
                    //         animation: "Preview2"),
                    //   )),
                    //   radius: _width / 12,
                    // ),
                  ],
                ),
                Stack(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                      width: _width,
                      child: Text(
                        'Trash',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 60,
                          fontFamily: 'StarJedi',
                        ),
                      ),
                    ),
                    Positioned(
                      top: 45,
                      width: _width,
                      child: Text(
                        'Troopers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 34,
                          fontFamily: 'Starjhol',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'NOT YOUR WASTE, \nBUT YOUR PLANET.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor.withOpacity(0.77),
                  fontSize: 20,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
