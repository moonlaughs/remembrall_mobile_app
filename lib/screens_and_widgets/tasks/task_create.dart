import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';

///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:to_do_application/Models/user.dart';
import 'package:to_do_application/constants.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';
import 'package:to_do_application/models/decodedToken.dart';
import 'package:to_do_application/screens_and_widgets/home/custom_app_bar.dart';

class TaskCreateScreen extends StatefulWidget {
  @override
  _TaskCreateScreen createState() => _TaskCreateScreen();
}

class _TaskCreateScreen extends State<TaskCreateScreen> {
  HttpClient client = new HttpClient();
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  final myDescriptionController = TextEditingController();
  final myDateController = TextEditingController();
  final myTimeController = TextEditingController();
  final myLocationController = TextEditingController();
  final myPriorityController = TextEditingController();
  final myTagController = TextEditingController();
  var myUserId;
  String username = "";
  Uri url; // = Uri.https('10.0.2.2:5001', '/users/' + myUserId);

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myDescriptionController.dispose();
    myDateController.dispose();
    myTimeController.dispose();
    myLocationController.dispose();
    myPriorityController.dispose();
    myTagController.dispose();
    super.dispose();
  }

  getUser() async {
    try {
      var myParesedToken = parseJwt(myStorage.getItem('token'));
      DecodedToken myDecodedToken = DecodedToken.fromJson(myParesedToken);
      // print(myDecodedToken.nameid);

      Uri url2 = Uri.https('10.0.2.2:5001', '/users/' + myDecodedToken.nameid);

      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.getUrl(url2);

      // request.headers.set('content-type', 'application/json');
      String myBearer = 'Bearer ' + myStorage.getItem('token');
      // print(myBearer);
      request.headers.set('Authorization', myBearer);

      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        // print(response.statusCode);
        // String receivedString = await response.transform(utf8.decoder).join();
        // var myJson = json.decode(receivedString);
        // User myUser = User.fromJson(myJson);
        // print(myUser.id);
        setState(() {
          myUserId = myDecodedToken.nameid;
          // url = Uri.https('10.0.2.2:5001', '/users/' + myUserId);
          url = Uri.https('10.0.2.2:5001', '/todos');
        });
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

  createTask() async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      String myDescription = myDescriptionController.text;
      // String myDate = myDateController.text;
      // String myTime = myTimeController.text;
      String myLocation = myLocationController.text;
      // String myPriority = myPriorityController.text;
      String myTag = myTagController.text;
      int priority = 1; // nneds to be adapted to 0

      Map map;
      if (myDescription == null || myTag == null) {
        _showDialog(context,
            'Please fill up required information in order to create a task\nDescription and Tag is required');
      } else {
        // if (myPriority == null || myPriority == "") {}
        map = {
          "description": myDescription,
          "date": "2021-05-07T19:52:15.671Z",
          "time": "2021-05-07T19:52:15.671Z",
          "location": myLocation,
          "priority": priority,
          "fkTagId": "ae2d605e-2392-4a86-b3a2-bf75c486f332",
          "fkUserId": myUserId
        };
        HttpClientRequest request = await client.postUrl(url);

        request.headers.set('content-type', 'application/json');

        request.add(utf8.encode(json.encode(map)));

        HttpClientResponse response = await request.close();
        String reply = await response.transform(utf8.decoder).join();
        print(reply);
        if(response.statusCode == 201){
          print('created a task');
          Navigator.pushNamed(context, Constants.HOME_SCREEN);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showDialog(BuildContext context, String dialogMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(dialogMessage),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Ok"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
      appBar: CustomAppBar("REMEMBRALL"),
      body: SingleChildScrollView(
          child: Column(
        children: [_buildProgressBar(context), _buildUpdateForm(context)],
      )),
      backgroundColor: Colors.cyan,
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Container(
      // color: Colors.cyan,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25.0),
            bottomLeft: Radius.circular(25.0)),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          'ADD NEW TASK',
          style: TextStyle(color: Colors.white, fontSize: 20),
        )),
      ),
    );
  }

  Widget _buildUpdateForm(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.4;
    double buttonHeight = MediaQuery.of(context).size.height * 0.05;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
              controller: myDescriptionController,
              obscureText: false,
              decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: "Type description...",
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true)),
          Divider(
            color: Colors.white,
          ),
          TextField(
              controller: myDateController,
              obscureText: false,
              decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: "Type Date...",
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true)),
          Divider(
            color: Colors.white,
          ),
          TextField(
              controller: myTimeController,
              obscureText: false,
              decoration: InputDecoration(
                  labelText: 'Time',
                  hintText: "Type Time...",
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true)),
          Divider(
            color: Colors.white,
          ),
          TextField(
            controller: myLocationController,
            obscureText: false,
            decoration: InputDecoration(
                labelText: 'Location',
                hintText: "Type location...",
                border: InputBorder.none,
                fillColor: Colors.transparent,
                filled: true),
          ),
          Divider(
            color: Colors.white,
          ),
          TextField(
              controller: myPriorityController,
              obscureText: false,
              decoration: InputDecoration(
                  labelText: 'Priority',
                  hintText: "Type priority...",
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true)),
          Divider(
            color: Colors.white,
          ),
          TextField(
              controller: myTagController,
              obscureText: false,
              decoration: InputDecoration(
                  labelText: 'Tag',
                  hintText: "Type tag...",
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true)),
          Divider(
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: GestureDetector(
              onTap: () {
                createTask();
              },
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  color: Colors.teal,
                ),
                child: Center(
                  child: AutoSizeText('Create Task',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 1),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
