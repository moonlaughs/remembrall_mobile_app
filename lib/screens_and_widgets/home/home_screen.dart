import 'dart:convert';
import 'dart:io';

// import 'package:auto_size_text/auto_size_text.dart';

///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:to_do_application/constants.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';
// import 'package:to_do_application/models/decodedToken.dart';
import 'package:to_do_application/models/task.dart';

import 'custom_app_bar.dart';
import 'custom_drower.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  HttpClient client = new HttpClient();
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  var myUserId;
  String username = "";
  Uri url;
  List<MyTask> myTasks = [];

  Future myFutureItems;

  @override
  void initState() {
    super.initState();
    myFutureItems = getToDos();
  }

  getToDos() async {
    try {
      url = Uri.https('10.0.2.2:5001', '/todos');
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
        return myTasks;
      }
    } catch (e) {
      print(e);
    }
  }

  deleteToDo(String taskId) async {
    try {
      url = Uri.https('10.0.2.2:5001', '/todos/$taskId');
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
      appBar: CustomAppBar("REMEMBRALL"),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          _buildProgressBar(context),
          _buildListView(context),
          // _buildList(),
          // FutureBuilder(
          //   future: getToDos(),
          //   builder: (context, snapshot){
          //     if(snapshot.hasData == null){
          //       return Container(child: AutoSizeText('Sorry, no tasks found.', maxLines: 1,),);
          //     }
          //     return _buildListView(context);
          // })
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
      builder: (context, snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('none');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('');
          case ConnectionState.done:
          List<Widget> myWidgets = [];
          snapshot.data.forEach((item){
            myWidgets.add(_buildTask(context, Colors.pink, item, snapshot.data.indexOf(item)));
          });
          return Column(
            children: myWidgets,
          );
    //       return new ListView.builder(
    //   itemCount: snapshot.data.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     String key = snapshot.data.elementAt(index).description;
    //     return new Column(
    //       children: <Widget>[
    //         new ListTile(
    //           title: new Text("$key"),
    //           // subtitle: new Text("${myData[index]}"),
    //           trailing: Icon(Icons.arrow_right),
    //           onTap: () {
    //             //DisplayAllImages
    //           },
    //         ),
    //         new Divider(
    //           height: 2.0,
    //         ),
    //       ],
    //     );
    //   },
    // );
          default:
            return Text('default');
        }
      });
    
  }
  Widget _buildTask(BuildContext context, Color tagColor, MyTask myTask, int index) {
    return Dismissible(
      key: Key(myTask.id),
      onDismissed: (direction){
        setState(() {
                  myTasks.removeAt(index);
                });
      },
      confirmDismiss: (direction) async {
        if(direction == DismissDirection.startToEnd){
          final bool res = await showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                content: Text('Are you sure you want to delete ${myTask.description}?'),
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
            }
          );
          return res;
        } else {
          print(myTask.id);
          myStorage.setItem('taskToUpdate', myTask.toJson());
          Navigator.pushNamed(context, Constants.UPDATE_TASK_SCREEN);
          return null;
        }
      },
      background: slideRightBackground(),//Container(color: Colors.red,),
      secondaryBackground: slideLeftBackground(),//Container(color: Colors.green),
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
              color: tagColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 20),
            child: Container(
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 300.0, top: 20),
            child: Container(
              height: 35,
              width: 35,
              // width: MediaQuery.of(context).size.width/ 2,
              // color: Colors.green,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                color: Colors.green,
              ),
              child: Center(
                  child: Text(
                '✓',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              )),
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
              child: Center(
                  child: Text(
                '10:00 AM',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              )),
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
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: 20,
              // color: Colors.white,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                color: Colors.white,
              ),
              child: Container(
                height: 20,
                width: 20,
                // width: MediaQuery.of(context).size.width/ 2,
                // color: Colors.green,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: Colors.green,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
