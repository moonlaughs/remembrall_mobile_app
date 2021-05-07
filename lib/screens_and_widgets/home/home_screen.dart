///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';

import 'custom_app_bar.dart';
import 'custom_drower.dart';

///Widgets used in this class

class HomeScreen extends StatelessWidget {
  static LocalStorage myStorage = LocalStorageHelper().getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("REMEMBRALL"),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          _buildProgressBar(context),
          _buildTask(context, Colors.pink),
          _buildTask(context, Colors.green),
          _buildTask(context, Colors.pink),
          _buildTask(context, Colors.blue),
          _buildTask(context, Colors.pink),
          _buildTask(context, Colors.pink),
        ],
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

  Widget _buildTask(BuildContext context, Color tagColor) {
    return GestureDetector(
      onTap: () {
        // print('task');
        Navigator.pushNamed(context, '/createTask');
      },
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
                'Work Meeting',
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
}
