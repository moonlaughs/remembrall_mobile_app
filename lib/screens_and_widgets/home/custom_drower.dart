import 'package:auto_size_text/auto_size_text.dart';
///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';

///Widget that allowed me to have a fully customizable App Bar at the top of the screens
class CustomDrawer extends StatelessWidget {
  static LocalStorage myStorage = LocalStorageHelper().getInstance();

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 44,
                  minHeight: 44,
                  maxWidth: 44,
                  maxHeight: 44,
                ),
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
              AutoSizeText(
                'Settings',
                // tr('txt_settings'),
                style: TextStyle(fontSize: 20, color: Colors.white),
                maxLines: 1,
              ),
            ],
          ), //'Settings'),
          decoration: BoxDecoration(
            color: Colors.lightBlue[400],
          ),
        ),
        ListTile(
          title: AutoSizeText(
            'Home',
            // tr('txt_home'),
            style: TextStyle(fontSize: 20),
            maxLines: 1,
          ),
          leading: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 44,
              minHeight: 44,
              maxWidth: 44,
              maxHeight: 44,
            ),
            child: Icon(Icons.home),
          ),
          onTap: () {
            // if(myStorage.getItem('processItem') != null){
            //     Navigator.of(context).pushNamedAndRemoveUntil('/chosenFaceScreen', (Route<dynamic> route) => false);
            //   } else {
            //     Navigator.of(context).pushNamedAndRemoveUntil('/mainScreen', (Route<dynamic> route) => false);
            //   }
          },
        ),
        ListTile(
          title: AutoSizeText(
            'ToDos',
            // tr('txt_stats'),
            style: TextStyle(fontSize: 20),
            maxLines: 1,
          ),
          leading: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 44,
              minHeight: 44,
              maxWidth: 44,
              maxHeight: 44,
            ),
            child: Icon(Icons.show_chart_rounded),
          ),
          onTap: () {
            // Navigator.pushNamed(context, '/statistics');
          },
        ),
        ListTile(
          title: AutoSizeText(
            'Profile',
            // tr('txt_change_language'),
            style: TextStyle(fontSize: 20),
            maxLines: 1,
          ),
          leading: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 44,
              minHeight: 44,
              maxWidth: 44,
              maxHeight: 44,
            ),
            child: Icon(Icons.translate),
          ),
          onTap: () {
            // Navigator.pushNamed(context, '/changeLanguage');
          },
        ),
      ],
    ));
  }
}
