///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';  
import 'package:localstorage/localstorage.dart';
// import 'package:auto_size_text/auto_size_text.dart';
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
      // title: Center(
      //   child: AutoSizeText(
      //     title,
      //     style:  TextStyle(color: Colors.black),
      //     maxLines: 1,
      //   ),
      // ),
      backgroundColor: Colors.cyan,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/userProfile');
              // if(myStorage.getItem('processItem') != null){
              //   Navigator.of(context).pushNamedAndRemoveUntil('/chosenFaceScreen', (Route<dynamic> route) => false);
              // } else {
              //   Navigator.of(context).pushNamedAndRemoveUntil('/mainScreen', (Route<dynamic> route) => false);
              // }
            },
            child: Row(
              children: [
                Text('Jane Doe'),
                Padding(padding: EdgeInsets.only(right: 8)),
                Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new AssetImage('assets/otherImages/girl.png',) 
                                // new NetworkImage(
                                //     "https://i.imgur.com/BoN9kdC.png")
                            )
                        )),
              ],
            ),
            // child: Image.asset('assets/otherImages/girl.png', scale: 1.5),
          )
        )
      ],
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}