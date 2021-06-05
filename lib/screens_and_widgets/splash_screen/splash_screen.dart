import 'dart:convert';
import 'dart:io';

///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

///package to use Timer
import 'dart:async';

import 'package:to_do_application/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';
import 'package:to_do_application/models/decodedToken.dart';
import 'package:to_do_application/models/user.dart';

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
  SharedPreferences prefs;
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  // Uri url = Uri.https('10.0.2.2:5001', '/users/authenticate');
  HttpClient client = new HttpClient();

  @override
  void initState() {
    super.initState();
    _splash();
  }

  _splash() async {
    prefs = await SharedPreferences.getInstance();
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    var login = prefs.getString('login');
    var token = myStorage.getItem('token');
    if (login == null || token == null) {
      myStorage.clear();
      Navigator.pushNamed(context, Constants.LOGIN_SCREEN);
    } else {
      getUser();
    }
  }

  getUser() async {
    try {
      var myParesedToken = parseJwt(myStorage.getItem('token'));
      DecodedToken myDecodedToken = DecodedToken.fromJson(myParesedToken);
      print(myDecodedToken.nameid);
      
      Uri url2 = Uri.https('10.0.2.2:5001', '/users/' + myDecodedToken.nameid);

      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.getUrl(url2);

      // request.headers.set('content-type', 'application/json');
      String myBearer = 'Bearer ' + myStorage.getItem('token');
      print(myBearer);
      request.headers.set('Authorization', myBearer);

      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        print(response.statusCode);
        String receivedString = await response.transform(utf8.decoder).join();
        var myJson = json.decode(receivedString);
        User myUser = User.fromJson(myJson);
        print(myUser.id);
        prefs.setString('userId', myUser.id.toString());
        print(prefs.getString('userId'));
        // prefs.setString('user', myJson);
      Navigator.pushNamed(context, Constants.HOME_SCREEN);
      }
    } catch (e) {
      print(e);
    }
  }

   Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
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
