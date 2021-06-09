import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';
import 'package:to_do_application/models/tag.dart';
import 'package:to_do_application/screens_and_widgets/home/custom_app_bar.dart';
import 'package:to_do_application/screens_and_widgets/home/custom_drower.dart';

import '../../constants.dart';
class TagsList extends StatefulWidget {
  // const TagsList({ Key? key }) : super(key: key);

  @override
  _TagsListState createState() => _TagsListState();
}

class _TagsListState extends State<TagsList> {
  HttpClient client = new HttpClient();
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  SharedPreferences prefs;
  var myUserId;
  Future myFutureItems;
  List<Tag> tagsList = [];
  // Uri url;
  @override
  void initState() {
    super.initState();
    myFutureItems = getTags();
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
      print(myBearer);
      // request.headers.add('Authorization', myBearer);
      // request.headers = headers;

      HttpClientResponse response = await request.close();
      print(response.statusCode);
      String reply = await response.transform(utf8.decoder).join();
      print(reply);
      if (response.statusCode == 200) {
        // setState(() {
        tagsList =
            (json.decode(reply) as List).map((i) => Tag.fromJson(i)).toList();

        // Tag tObj = Tag().getInstance();
        // tObj.setTags(tagsList);
        return tagsList;

        // tagsList.forEach((element) {
        //   print(element.tagName);
        //   tagsNames.add(element.tagName);
        // });
        // myStorage.setItem('tagsNames', tagsNames);
        // });
      }
    } catch (e) {
      print(e);
    }
  }

  deleteTag(String tagId) async {
    try {
      Uri url = Uri.https('10.0.2.2:5001', '/tags/$tagId');
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.deleteUrl(url);

      HttpClientResponse response = await request.close();
      print(response.statusCode); //204
      setState(() {
        myFutureItems = getTags();
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
            // Padding(padding: EdgeInsets.only(top:20)),
            _buildTagListView(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Constants.CREATE_TAG_SCREEN);
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

  _buildTagListView(BuildContext context){
    // if (tagsList.length == 0) {
    //   return Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Center(child: Text("No tags found")),
    //   );
    // }
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
                    _buildTag(context, item, snapshot.data.indexOf(item)));
              });
              return Column(
                children: myWidgets,
              );
            default:
              return Text('default');
          }
        });
  }

  _buildTag(BuildContext context, Tag myTag, int index){
    
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dismissible(
        key: Key(myTag.id),
        onDismissed: (direction) {
          setState(() {
            tagsList.removeAt(index);
          });
        },
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            final bool res = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Text(
                        'Are you sure you want to delete ${myTag.tagName}?'),
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
                          deleteTag(myTag.id);
                          setState(() {
                            tagsList.removeAt(index);
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            return res;
          } else {
            print(myTag.id);
            myStorage.setItem('tagToUpdate', myTag.toJson());
            Navigator.pushNamed(context, Constants.UPDATE_TAG_SCREEN);
            return null;
          }
        },
        background: slideRightBackground(), //Container(color: Colors.red,),
        secondaryBackground:
            slideLeftBackground(), //Container(color: Colors.green),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
              color: returnTagColor(myTag.tagColor),
            ),
            height: 50,
            width: MediaQuery.of(context).size.width - 20,
            // color: Colors.blue,//returnTagColor(myTag.tagColor),
            child: Center(child: Text(myTag.tagName, style: TextStyle(fontSize: 24),)),
          ),
        ),
        // ),
      ),
    );
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
    } else {
      return Colors.white;
    }
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
}