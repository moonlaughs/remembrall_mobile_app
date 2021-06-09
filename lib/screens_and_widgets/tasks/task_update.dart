import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';

///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:to_do_application/Models/user.dart';
import 'package:to_do_application/constants.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';
// import 'package:to_do_application/models/decodedToken.dart';
import 'package:to_do_application/models/task.dart';
import 'package:to_do_application/screens_and_widgets/home/custom_app_bar.dart';

import 'package:shared_preferences/shared_preferences.dart';
class TaskUpdateScreen extends StatefulWidget {
  @override
  _TaskUpdateScreen createState() => _TaskUpdateScreen();
}

class _TaskUpdateScreen extends State<TaskUpdateScreen> {
  MyTask taskToUpdate;
  HttpClient client = new HttpClient();
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  final myDescriptionController = TextEditingController();
  final myDateController = TextEditingController();
  final myLocationController = TextEditingController();
  // final myPriorityController = TextEditingController();
  var myUserId;
  String username = "";
  String dropdownValue;// = 'Choose Priority';
  Uri url; // = Uri.https('10.0.2.2:5001', '/users/' + myUserId);
  SharedPreferences prefs;
  List<String> priorities = ['Choose Priority', 'Low', 'Medium', 'High'];

  @override
  void initState() {
    super.initState();
    getUser();
    taskToUpdate = getTaskToUpdate();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myDescriptionController.dispose();
    myDateController.dispose();
    myLocationController.dispose();
    // myPriorityController.dispose();
    super.dispose();
  }

  getTaskToUpdate(){
    Map<String, dynamic> item = myStorage.getItem('taskToUpdate');
    if (item == null) {
        return null;
      }
    MyTask myTask = MyTask.fromJsonOnUpdate(item);
    print(myTask.description);
    setState(() {
      
          myDescriptionController.text = myTask.description;
          myDateController.text = myTask.dateTime;
          myLocationController.text = myTask.location;
          dropdownValue = priorities[myTask.priority];

        });
        return myTask;
  }

  getUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      myUserId = prefs.get('userId');
    });
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

  updateTask() async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      String myDescription = myDescriptionController.text;
      String myDate = myDateController.text;
      String myLocation = myLocationController.text;
      String myPriority = priorities.indexOf(dropdownValue).toString();

      Map map;
      if (myDescription == null) {
        _showDialog(context,
            'Please fill up required information in order to update a task\nDescription is required');
      } else {
        // if (myPriority == null || myPriority == "") {}
        map = {
  "description": myDescription,
  "datetime": myDate,
  "location": myLocation,
  "priority": myPriority
};
Uri url3 = Uri.https('10.0.2.2:5001', '/todos/${taskToUpdate.id}');
        HttpClientRequest request = await client.putUrl(url3);

        request.headers.set('content-type', 'application/json');

        request.add(utf8.encode(json.encode(map)));

        HttpClientResponse response = await request.close();
        String reply = await response.transform(utf8.decoder).join();
        print(reply);
        print(response.statusCode);
        if(response.statusCode == 204){
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
          'UPDATE TASK',
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
          // TextField(
          //     controller: myDateController,
          //     obscureText: false,
          //     decoration: InputDecoration(
          //         labelText: 'Date',
          //         hintText: "Type Date...",
          //         border: InputBorder.none,
          //         fillColor: Colors.transparent,
          //         filled: true)),
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
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: myDateController.text == null ? "Choose date and time " : myDateController.text,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                        WidgetSpan(
                          child: Icon(Icons.date_range, size: 24),
                        ),
                        // TextSpan(
                        //   text: " to add",
                        // ),
                      ],
                    ),
                  )
                  // AutoSizeText('Pick date and time'),
                  )),
          Divider(
            color: Colors.white,
          ),
          
          DropdownButton<String>(
            value: dropdownValue,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: priorities
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: GestureDetector(
              onTap: () {
                updateTask();
              },
              child: Container(
                width: buttonWidth,
                height: buttonHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  color: Colors.teal,
                ),
                child: Center(
                  child: AutoSizeText('Update Task',
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
