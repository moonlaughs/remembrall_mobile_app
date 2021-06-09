import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';
import 'package:to_do_application/screens_and_widgets/home/custom_app_bar.dart';

import '../../constants.dart';
class TagCreateScreen extends StatefulWidget {
  // const TagCreateScreen({ Key? key }) : super(key: key);

  @override
  _TagCreateScreenState createState() => _TagCreateScreenState();
}

class _TagCreateScreenState extends State<TagCreateScreen> {
  HttpClient client = new HttpClient();
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  String dropdownValueTag = 'Blue';
  List<String> myColors = ['Blue', 'Green', 'Orange', 'Red'];
  var myUserId;
  SharedPreferences prefs;
  Uri url;
  final myTagNameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myTagNameController.dispose();
    super.dispose();
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
      // String tagName = 'new Tag';
      // String myTime = myTimeController.text;
      // String tagColor = 'green';
      String tagName = myTagNameController.text;
      int tagColor = myColors.indexOf(dropdownValueTag);
      Map map;
      if (tagName == null || tagColor == null) {
        _showDialog(context,
            'Please fill up required information in order to create a tag');
      } else {
        // if (myPriority == null || myPriority == "") {}
        map = {
          "tagName": tagName,
          "tagColor": myColors[tagColor],
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
          print('created a tag');
          // Navigator.pop(context);
          Navigator.pushNamed(context, Constants.TAG_SCREEN);
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
          'ADD NEW TAG',
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
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
            child: TextField(
                controller: myTagNameController,
                obscureText: false,
                decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: "Type name...",
                    border: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: true)),
          ),
          DropdownButton<String>(
                      value: dropdownValueTag,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      // style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValueTag = newValue;
                        });
                      },
                      items: <String>['Blue', 'Green', 'Orange', 'Red']
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
                  child: AutoSizeText('Create Tag',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      maxLines: 1),
                ),
              ),
            ),
          ),
        ],
      )
  );
  }
}