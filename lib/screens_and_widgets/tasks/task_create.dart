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
import 'package:to_do_application/models/tag.dart';
import 'package:to_do_application/screens_and_widgets/home/custom_app_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TaskCreateScreen extends StatefulWidget {
  @override
  _TaskCreateScreen createState() => _TaskCreateScreen();
}

class _TaskCreateScreen extends State<TaskCreateScreen> {
  HttpClient client = new HttpClient();
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  final myDescriptionController = TextEditingController();
  final myDateController = TextEditingController();
  final myLocationController = TextEditingController();
  final myPriorityController = TextEditingController();
  final myTagController = TextEditingController();
  var myUserId;
  String username = "";
  Uri url;
  SharedPreferences prefs;
  String dropdownValue = 'Choose Priority';
  List<Tag> tagsList = [];
  List<String> tagsNames = [];
  Tag tObj = Tag().getInstance();
  String dropdownValue2 = 'Add a tag';

  @override
  void initState() {
    super.initState();
    getTags();
  }

  getTags() {
    tagsList = tObj.getTags();
    tagsNames.add('Add a tag');
    tagsList.forEach((element) {
      tagsNames.add(element.tagName);
      print(element.tagName);
    });

//     prefs = await SharedPreferences.getInstance();
// try {
//       client.badCertificateCallback =
//           ((X509Certificate cert, String host, int port) => true);
//       myUserId = prefs.get('userId');
//         url = Uri.https('10.0.2.2:5001', '/tags/user/' + myUserId);
//         print(myUserId);
//         HttpClientRequest request = await client.getUrl(Uri.https('10.0.2.2:5001', '/tags/user/' + myUserId));
//         // Map<String, String> headers = {};
//         // headers['content-type'] = 'application/json';

//         // request.headers.set('content-type', 'application/json');
//         String myBearer = 'Bearer ' + myStorage.getItem('token');
//         // headers['Authorization'] = myBearer;
//         request.headers.add('content-type', 'application/json');
//         // String myBearer = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI1ZmUyNGYzOC0zNjE5LTRlNTEtYmNjMy1kOGNlYTdkYTIwZjMiLCJuYmYiOjE2MjI1NjQzODMsImV4cCI6MTYyMjY1MDc4MywiaWF0IjoxNjIyNTY0MzgzfQ.ERCDSwfmoj7u1TrAvLWv7Cq3cgU94_oSk2d4YHlSjxo';
//         print(myBearer);
//         // request.headers.add('Authorization', myBearer);
//         // request.headers = headers;

//         HttpClientResponse response = await request.close();
//         print(response.statusCode);
//         String reply = await response.transform(utf8.decoder).join();
//         print(reply);
//         if (response.statusCode == 200) {
//           setState(() {
//                        tagsList = (json.decode(reply) as List)
//               .map((i) => Tag.fromJson(i))
//               .toList();

//               tagsList.forEach((element) {
//                 print(element.tagName);
//                 tagsNames.add(element.tagName);
//               });
//                     });
//         }
//     } catch (e) {
//       print(e);
//     }
  }

  createTag() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myUserId = prefs.get('userId');
      url = Uri.https('10.0.2.2:5001', '/tags');
    });
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      String tagName = 'new Tag';
      // String myTime = myTimeController.text;
      String tagColor = 'green';
      Map map;
      if (tagName == null || tagColor == null) {
        _showDialog(context,
            'Please fill up required information in order to create a tag');
      } else {
        // if (myPriority == null || myPriority == "") {}
        map = {"tagName": tagName, "tagColor": tagColor, "fkUserId": myUserId};
        HttpClientRequest request = await client.postUrl(url);
        // Map<String, String> headers = {};
        // headers['content-type'] = 'application/json';

        // request.headers.set('content-type', 'application/json');
        String myBearer = 'Bearer ' + myStorage.getItem('token');
        // headers['Authorization'] = myBearer;
        request.headers.add('content-type', 'application/json');
        // String myBearer = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI1ZmUyNGYzOC0zNjE5LTRlNTEtYmNjMy1kOGNlYTdkYTIwZjMiLCJuYmYiOjE2MjI1NjQzODMsImV4cCI6MTYyMjY1MDc4MywiaWF0IjoxNjIyNTY0MzgzfQ.ERCDSwfmoj7u1TrAvLWv7Cq3cgU94_oSk2d4YHlSjxo';
        print(myBearer);
        // request.headers.add('Authorization', myBearer);
        // request.headers = headers;

        request.add(utf8.encode(json.encode(map)));
        print(map);
        HttpClientResponse response = await request.close();
        print(response.statusCode);
        String reply = await response.transform(utf8.decoder).join();
        print(reply);
        if (response.statusCode == 201) {
          print('created a tag');
          Navigator.pushNamed(context, Constants.HOME_SCREEN);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myDescriptionController.dispose();
    myDateController.dispose();
    myLocationController.dispose();
    myPriorityController.dispose();
    myTagController.dispose();
    super.dispose();
  }

  // getUser() async {
  //   prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //         myUserId = prefs.get('userId');
  //         url = Uri.https('10.0.2.2:5001', '/users/' + myUserId);
  //       });
  //   // try {
  //   //   var myParesedToken = parseJwt(myStorage.getItem('token'));
  //   //   DecodedToken myDecodedToken = DecodedToken.fromJson(myParesedToken);
  //   //   // print(myDecodedToken.nameid);

  //   //   Uri url2 = Uri.https('10.0.2.2:5001', '/users/' + myDecodedToken.nameid);

  //   //   client.badCertificateCallback =
  //   //       ((X509Certificate cert, String host, int port) => true);
  //   //   HttpClientRequest request = await client.getUrl(url2);

  //   //   // request.headers.set('content-type', 'application/json');
  //   //   String myBearer = 'Bearer ' + myStorage.getItem('token');
  //   //   // print(myBearer);
  //   //   request.headers.set('Authorization', myBearer);

  //   //   HttpClientResponse response = await request.close();
  //   //   if (response.statusCode == 200) {
  //   //     // print(response.statusCode);
  //   //     // String receivedString = await response.transform(utf8.decoder).join();
  //   //     // var myJson = json.decode(receivedString);
  //   //     // User myUser = User.fromJson(myJson);
  //   //     // print(myUser.id);
  //   //     setState(() {
  //   //       myUserId = myDecodedToken.nameid;
  //   //       // url = Uri.https('10.0.2.2:5001', '/users/' + myUserId);
  //   //       url = Uri.https('10.0.2.2:5001', '/todos');
  //   //     });
  //   //   }
  //   // } catch (e) {
  //   //   print(e);
  //   // }
  // }

  // Map<String, dynamic> parseJwt(String token) {
  //   final parts = token.split('.');
  //   if (parts.length != 3) {
  //     throw Exception('invalid token');
  //   }

  //   final payload = _decodeBase64(parts[1]);
  //   final payloadMap = json.decode(payload);
  //   if (payloadMap is! Map<String, dynamic>) {
  //     throw Exception('invalid payload');
  //   }

  //   return payloadMap;
  // }

  createTask() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myUserId = prefs.get('userId');
      url = Uri.https('10.0.2.2:5001', '/todos');
    });
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      String myDescription = myDescriptionController.text;
      String myDate = myDateController.text;
      // String myTime = myTimeController.text;
      String myLocation = myLocationController.text;
      // String myPriority = myPriorityController.text;
      String myTag = myTagController.text;
      // int priority = int.parse(myPriorityController.text);
      List<String> myPriorities = ['Choose Priority', 'Low', 'Medium', 'High'];
      int priority = myPriorities.indexOf(dropdownValue);

      print('drop: $dropdownValue');
      Map map;
      if (myDescription == null || myTag == null) {
        _showDialog(context,
            'Please fill up required information in order to create a task\nDescription and Tag is required');
      } else {
        // if (myPriority == null || myPriority == "") {}
        map = {
          "description": myDescription,
          "dateTime": myDate, //"2021-06-01T14:16:14.985Z",
          "location": myLocation,
          "priority": priority,
          "done": false,
          // "fkTagId": "ae2d605e-2392-4a86-b3a2-bf75c486f332",
          "fkUserId": myUserId
        };
        HttpClientRequest request = await client.postUrl(url);
        // Map<String, String> headers = {};
        // headers['content-type'] = 'application/json';

        // request.headers.set('content-type', 'application/json');
        String myBearer = 'Bearer ' + myStorage.getItem('token');
        // headers['Authorization'] = myBearer;
        request.headers.add('content-type', 'application/json');
        // String myBearer = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI1ZmUyNGYzOC0zNjE5LTRlNTEtYmNjMy1kOGNlYTdkYTIwZjMiLCJuYmYiOjE2MjI1NjQzODMsImV4cCI6MTYyMjY1MDc4MywiaWF0IjoxNjIyNTY0MzgzfQ.ERCDSwfmoj7u1TrAvLWv7Cq3cgU94_oSk2d4YHlSjxo';
        print(myBearer);
        // request.headers.add('Authorization', myBearer);
        // request.headers = headers;

        request.add(utf8.encode(json.encode(map)));
        print(map);
        HttpClientResponse response = await request.close();
        print(response.statusCode);
        String reply = await response.transform(utf8.decoder).join();
        print(reply);
        if (response.statusCode == 201) {
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
          GestureDetector(
              onTap: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2018, 3, 5),
                    maxTime: DateTime(2019, 6, 7), onChanged: (dateTime) {
                  myDateController.text = dateTime.toString();
                  print('change $dateTime in time zone ' +
                      dateTime.timeZoneOffset.inHours.toString());
                }, onConfirm: (dateTime) {
                  myDateController.text =
                      dateTime.toString().replaceAll(' ', 'T');
                  print('confirm $dateTime');
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText('Pick date and time'),
              )),
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
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            // style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              // color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['Choose Priority', 'Low', 'Medium', 'High']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // TextField(
          //     controller: myPriorityController,
          //     obscureText: false,
          //     decoration: InputDecoration(
          //         labelText: 'Priority',
          //         hintText: "Type priority...",
          //         border: InputBorder.none,
          //         fillColor: Colors.transparent,
          //         filled: true)),
          Divider(
            color: Colors.white,
          ),
          DropdownButton<String>(
            value: dropdownValue2,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            // style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              // color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue2 = newValue;
              });
            },
            items: tagsNames.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // TextField(
          //     controller: myTagController,
          //     obscureText: false,
          //     decoration: InputDecoration(
          //         labelText: 'Tag',
          //         hintText: "Type tag...",
          //         border: InputBorder.none,
          //         fillColor: Colors.transparent,
          //         filled: true)),
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: GestureDetector(
              onTap: () {
                createTag();
              },
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  color: Colors.teal,
                ),
                child: Center(
                  child: AutoSizeText('Create a new Tag',
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
