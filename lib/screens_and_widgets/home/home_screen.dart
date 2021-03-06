import 'dart:convert';
import 'dart:io';

// import 'package:auto_size_text/auto_size_text.dart';

///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:to_do_application/constants.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';
// import 'package:to_do_application/models/decodedToken.dart';
import 'package:to_do_application/models/tag.dart';
// import 'package:to_do_application/models/decodedToken.dart';
import 'package:to_do_application/models/task.dart';
// import 'package:to_do_application/models/user.dart';
// import 'package:to_do_application/screens_and_widgets/encryption/encryption.dart';

import 'custom_app_bar.dart';
import 'custom_drower.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  HttpClient client = new HttpClient();
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  SharedPreferences prefs;
  var myUserId;
  String username = "";
  // Uri url;
  List<MyTask> myTasks = [];

  List<Tag> tagsList = [];
  List<String> tagsNames = [];

  Future myFutureItems;
  double percentageDoneTasks = 0;
  int noOfTasks = 0;
  int noOfDONETasks = 0;

  @override
  void initState() {
    super.initState();
    // getUser();
    myFutureItems = getToDos();
    // percentageDoneTasks = getPercenage();
    getTags();
  }

  getTags() async {
    prefs = await SharedPreferences.getInstance();
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      myUserId = prefs.get('userId');
      // url = Uri.https('10.0.2.2:5001', '/tags/user/' + myUserId);
      print(myUserId);
      HttpClientRequest request = await client
          .getUrl(Uri.https('10.0.2.2:5001', '/tags/user/' + myUserId));
      String myBearer = 'Bearer ' + myStorage.getItem('token');
      request.headers.add('content-type', 'application/json');
      // String myBearer = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiI1ZmUyNGYzOC0zNjE5LTRlNTEtYmNjMy1kOGNlYTdkYTIwZjMiLCJuYmYiOjE2MjI1NjQzODMsImV4cCI6MTYyMjY1MDc4MywiaWF0IjoxNjIyNTY0MzgzfQ.ERCDSwfmoj7u1TrAvLWv7Cq3cgU94_oSk2d4YHlSjxo';
      // print(myBearer);
      request.headers.add('Authorization', myBearer);
      // request.headers = headers;

      HttpClientResponse response = await request.close();
      print(response.statusCode);
      String reply = await response.transform(utf8.decoder).join();
      print(reply);
      if (response.statusCode == 200) {
        // setState(() {
        tagsList =
            (json.decode(reply) as List).map((i) => Tag.fromJson(i)).toList();

        Tag tObj = Tag().getInstance();
        tObj.setTags(tagsList);

        tagsList.forEach((element) {
          print(element.tagName);
          tagsNames.add(element.tagName);
        });
        myStorage.setItem('tagsNames', tagsNames);
        // });
      }
    } catch (e) {
      print(e);
    }
  }

  getToDos() async {
    prefs = await SharedPreferences.getInstance();
    print('my prefs: ${prefs == null}');
    setState(() {
      myUserId = prefs.getString('userId');
    });
    try {
      print('here');
      print(myUserId);
      print(prefs == null);
      //  myUserId = prefs.getString('userId');
      print(myUserId);
      Uri url = Uri.https('10.0.2.2:5001', '/todos/user/$myUserId');
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.getUrl(url);

      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        print(response.statusCode);
        String receivedString = await response.transform(utf8.decoder).join();

        setState(() {
          myTasks = (json.decode(receivedString) as List)
              .map((i) => MyTask.fromJson(i))
              .toList();
        });

        print(myTasks[0].description);
        if (myTasks.length > 0) {
          getPercenage();
        }
        return myTasks;
      }
    } catch (e) {
      print(e);
    }
  }

  getPercenage() {
    percentageDoneTasks = 0;
    noOfDONETasks = 0;
    // myTasks = await myTasksListFuture;
    noOfTasks = myTasks.length;
    myTasks.forEach((element) {
      if (element.done) {
        noOfDONETasks++;
      }
    });
    percentageDoneTasks = noOfDONETasks / noOfTasks * 100;
    print('percentageDoneTasks: ${percentageDoneTasks.floor()}');
    return percentageDoneTasks;
  }

  deleteToDo(String taskId) async {
    try {
      Uri url = Uri.https('10.0.2.2:5001', '/todos/$taskId');
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.deleteUrl(url);

      HttpClientResponse response = await request.close();
      print(response.statusCode); //204
      setState(() {
        myFutureItems = getToDos();
      });
    } catch (e) {
      print(e);
    }
  }

  markTaskAsDone(String taskId) async {
    print(taskId);
    try {
      Uri url = Uri.https('10.0.2.2:5001', '/todos/$taskId');
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.patchUrl(url);

      HttpClientResponse response = await request.close();
      print(response.statusCode); //204
      setState(() {
        myFutureItems = getToDos();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("REMEMBRALL"),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          _buildProgressBar(context),
          _buildListView(context),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Constants.CREATE_TASK_SCREEN);
        },
        child: Center(
          child: Text(
            '+',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.cyan,
    );
  }

  _buildListView(BuildContext context) {
    if (myTasks.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text("No tasks found")),
      );
    }
    return FutureBuilder(
        future: myFutureItems,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('');
            case ConnectionState.done:
              List<Widget> myWidgets = [];
              snapshot.data.forEach((item) {
                myWidgets.add(
                    _buildTask(context, item, snapshot.data.indexOf(item)));
              });
              return Column(
                children: myWidgets,
              );
            default:
              return Text('default');
          }
        });
  }
  returnTagColor(String tagColor){
    if(tagColor == 'Blue'){
      return Colors.blue;
    } else if(tagColor == 'Green'){
      return Colors.green;
    } else if(tagColor == 'Orange'){
      return Colors.orange;
    } else if(tagColor == 'Red'){
      return Colors.red;
    } 
    else {
      return Colors.transparent;
    }
  }

  Widget _buildTask(BuildContext context, MyTask myTask, int index) {
    String dateToConvert = myTask.dateTime;
    DateTime dateTime = DateTime.parse(dateToConvert);
    String date = dateTime.toString().split(" ")[0];
    String time = dateTime.toString().split(" ")[1].substring(0, 5);
    return Dismissible(
      key: Key(myTask.id),
      onDismissed: (direction) {
        setState(() {
          myTasks.removeAt(index);
        });
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          final bool res = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                      'Are you sure you want to delete ${myTask.description}?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        deleteToDo(myTask.id);
                        setState(() {
                          myTasks.removeAt(index);
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
          return res;
        } else {
          print(myTask.id);
          myStorage.setItem('taskToUpdate', myTask.toJson());
          Navigator.pushNamed(context, Constants.UPDATE_TASK_SCREEN);
          return null;
        }
      },
      background: slideRightBackground(), //Container(color: Colors.red,),
      secondaryBackground:
          slideLeftBackground(), //Container(color: Colors.green),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: 20,
            // width: MediaQuery.of(context).size.width/ 2,
            // color: Colors.green,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                color: returnTagColor(myTask.tag.tagColor)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 20),
            child: myTask.priority == 3
                ? Container(
                    height: 35,
                    width: 35,
                    // width: MediaQuery.of(context).size.width/ 2,
                    // color: Colors.green,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      color: Colors.red,
                    ),
                    child: Center(
                        child: Text(
                      '!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )),
                  )
                : Container(
                    height: 35,
                    width: 35,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 300.0, top: 20),
            child: GestureDetector(
              onTap: () {
                markTaskAsDone(myTask.id);
              },
              child: Container(
                height: 35,
                width: 35,
                // width: MediaQuery.of(context).size.width/ 2,
                // color: Colors.green,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: myTask.done ? Colors.green : Colors.grey,
                ),
                child: Center(
                    child: Text(
                  '???',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 75.0, top: 25),
            child: Container(
              height: 30,
              width: 80,
              // width: MediaQuery.of(context).size.width/ 2,
              // color: Colors.green,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                // color: Colors.green,
              ),
              child: Column(
                children: [
                  Center(
                      child: Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  )),
                  Center(
                      child: Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 170.0, top: 25),
            child: Container(
              height: 30,
              width: 100,
              // width: MediaQuery.of(context).size.width/ 2,
              // color: Colors.green,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                // color: Colors.green,
              ),
              child: Center(
                  child: Text(
                myTask.description,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  decoration: myTask.done ? TextDecoration.lineThrough : TextDecoration.none
                   
                ),
              )),
            ),
          ),
        ]),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              Text(
                " Edit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                " Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
        ),
      ),
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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              'YOUR TASKS THIS WEEK',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),
          Center(
            child: percentageDoneTasks > 65
                ? Text('${percentageDoneTasks.floor()}% completed',
                    style: TextStyle(fontSize: 18, color: Colors.green))
                : percentageDoneTasks > 30
                    ? Text('${percentageDoneTasks.floor()}% completed',
                        style: TextStyle(fontSize: 18, color: Colors.orange))
                    : Text('${percentageDoneTasks.floor()}% completed',
                        style: TextStyle(fontSize: 18, color: Colors.red)),
          )
          // Center(
          //   child: Container(
          //     width: MediaQuery.of(context).size.width - 50,
          //     height: 20,
          //     // color: Colors.white,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(25.0)),
          //       color: Colors.white,
          //     ),
          //     child: Container(
          //       height: 20,
          //       width: 20,
          //       // width: MediaQuery.of(context).size.width/ 2,
          //       // color: Colors.green,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(25.0)),
          //         color: Colors.green,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
