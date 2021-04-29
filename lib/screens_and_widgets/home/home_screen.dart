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
          child: Container(color: Colors.white, )),
    );
  }
}