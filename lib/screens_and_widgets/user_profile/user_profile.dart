import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';

///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';
import 'package:to_do_application/models/decodedToken.dart';
import 'package:to_do_application/models/user.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _disabled = true;
  HttpClient client = new HttpClient();
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  final myEmailController = TextEditingController();
  final myPassController = TextEditingController();
  final myPass1Controller = TextEditingController();
  final myPass2Controller = TextEditingController();
  final myPass3Controller = TextEditingController();
  var myUserId;
  String username = "";
      Uri url;// = Uri.https('10.0.2.2:5001', '/users/' + myUserId);

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      getUser();
    }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myEmailController.dispose();
    myPassController.dispose();
    myPass1Controller.dispose();
    myPass2Controller.dispose();
    myPass3Controller.dispose();
    super.dispose();
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
        setState(() {
                  myEmailController.text = myUser.email;
                  myPassController.text = 'somefakepassword';//myUser.password;
                  username = myUser.username;
                  myUserId = myDecodedToken.nameid;
                  url = Uri.https('10.0.2.2:5001', '/users/' + myUserId);
                });
      }
    } catch (e) {
      print(e);
    }
  }

  updateUser() async {
    try {
      if(myPass1Controller.text == myPass2Controller.text || myPass2Controller.text == myPass3Controller.text){
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.putUrl(url);
Map map = {"email": myEmailController.text, "password": myPass2Controller.text};
      String myBearer = 'Bearer ' + myStorage.getItem('token');
      request.headers.set('Authorization', myBearer);
request.headers.set('content-type', 'application/json');

            request.add(utf8.encode(json.encode(map)));
      HttpClientResponse response = await request.close();
      print(response.statusCode);
      }

    } catch (e) {
      print(e);
    }
  }

  deleteUser() async {
     try {
      
      // Uri url = Uri.https('10.0.2.2:5001', '/users/' + myUserId);

      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.deleteUrl(url);

      String myBearer = 'Bearer ' + myStorage.getItem('token');
      request.headers.set('Authorization', myBearer);

      HttpClientResponse response = await request.close();
      print(response.statusCode);
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
    double buttonWidth = MediaQuery.of(context).size.width * 0.4;
    double buttonHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 70.0),
          child: Text("View Profile"),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.cyan,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage(
                                'assets/otherImages/girl.png',
                              )
                              // new NetworkImage(
                              //     "https://i.imgur.com/BoN9kdC.png")
                              ))),
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    username,
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height / (1.95),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                        controller: myEmailController,
                        enabled: !_disabled,
                        obscureText: false,
                        decoration: InputDecoration(
                            labelText: _disabled ? "Email" : 'Email',
                            hintText: _disabled
                                ? "iza@mial45.com"
                                : "iza@mial45.com you can change here",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)),
                    Divider(
                      color: Colors.grey,
                    ),
                    _disabled ? TextField(
                        controller: myPassController,
                        enabled: !_disabled,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: "Password",
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true)) : 
                            Column(
                              children: [
                                TextField(
                        controller: myPass1Controller,
                        enabled: !_disabled,
                        obscureText: true,
                        decoration: InputDecoration(
                                labelText: 'Old Password',
                                hintText: "Write your old password",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                                Divider(
                      color: Colors.grey,
                    ),
                                TextField(
                        controller: myPass2Controller,
                        enabled: !_disabled,
                        obscureText: true,
                        decoration: InputDecoration(
                                labelText: 'New Password',
                                hintText: "Write your new password",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                                Divider(
                      color: Colors.grey,
                    ),
                                TextField(
                        controller: myPass3Controller,
                        enabled: !_disabled,
                        obscureText: true,
                        decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                hintText: 
                                    "Confirm your new password",
                                border: InputBorder.none,
                                fillColor: Colors.white,
                                filled: true)),
                              ],
                            ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            deleteUser();
                          },
                          child: Container(
                            width: buttonWidth,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              color: Colors.red,
                            ),
                            child: Center(
                              child: AutoSizeText('Delete Profile',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 1),
                            ),
                          ),
                        ),
                        _disabled ? GestureDetector(
                          onTap: () {
                            setState(() {
                              _disabled = !_disabled;
                            });
                          },
                          child: Container(
                            width: buttonWidth,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              color: Colors.teal,
                            ),
                            child: Center(
                              child: AutoSizeText('Update Profile',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 1),
                            ),
                          ),
                        ):
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              updateUser();
                              _disabled = !_disabled;
                            });
                          },
                          child: Container(
                            width: buttonWidth,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              color: Colors.teal,
                            ),
                            child: Center(
                              child: AutoSizeText('Save Changes',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top:20)),
                    GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil('/loginScreen', (Route<dynamic> route) => false);
                          },
                          child: Container(
                            width: buttonWidth,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              color: Colors.cyan,
                            ),
                            child: Center(
                              child: AutoSizeText('Log Out',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 1),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
