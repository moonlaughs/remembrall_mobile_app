import 'package:auto_size_text/auto_size_text.dart';

///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:to_do_application/screens_and_widgets/home/custom_app_bar.dart';

class TaskCreateScreen extends StatefulWidget {
  @override
  _TaskCreateScreen createState() => _TaskCreateScreen();
}

class _TaskCreateScreen extends State<TaskCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("REMEMBRALL"),
      body: SingleChildScrollView(
          child: Column(
        children: [
          _buildProgressBar(context),
          _buildUpdateForm(context)
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
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
              obscureText: false,
              decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: "Type location...",
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: true), ),
          Divider(
            color: Colors.white,
          ),
          TextField(
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
        ],
      ),
    );
  }
}
