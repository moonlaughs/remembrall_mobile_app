///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';

///package to use Timer
import 'dart:async';

import 'package:to_do_application/constants.dart';

/// this is a splash screen that goes off in the very beginning and give time to load/initialize the DB
class SplashScreen extends StatefulWidget {
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String _versionName = 'V1.0';
  final splashDelay = 2;

  @override
  void initState() {
    super.initState();
    _splash();
  }

   _splash() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushNamed(context, Constants.LOGIN_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/otherImages/girl.png",
                          height: 300,
                          width: 300,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Text(_versionName),
                      Spacer(
                        flex: 4,
                      ),
                      Text('REMEMBRALL'),
                      Spacer(),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
