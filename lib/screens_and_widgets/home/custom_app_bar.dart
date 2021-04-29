///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';  
import 'package:localstorage/localstorage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';

///Widget that allowed me to have a fully customizable App Bar at the top of the screens
class CustomAppBar extends StatelessWidget with PreferredSizeWidget{
  static LocalStorage myStorage = LocalStorageHelper().getInstance();

  @override
  final Size preferredSize;

  final String title;

  CustomAppBar(this.title, {Key key}) : preferredSize = Size.fromHeight(56.0), super(key: key);

  @override
  Widget build(BuildContext context){
    return AppBar(
      title: Center(
        child: AutoSizeText(
          title,
          style:  TextStyle(color: Colors.black),
          maxLines: 1,
        ),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {
              // if(myStorage.getItem('processItem') != null){
              //   Navigator.of(context).pushNamedAndRemoveUntil('/chosenFaceScreen', (Route<dynamic> route) => false);
              // } else {
              //   Navigator.of(context).pushNamedAndRemoveUntil('/mainScreen', (Route<dynamic> route) => false);
              // }
            },
            child: Image.asset('assets/otherImages/girl.png', scale: 1.5),
          )
        )
      ],
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }
}