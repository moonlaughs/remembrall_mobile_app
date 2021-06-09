import 'package:auto_size_text/auto_size_text.dart';
///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:to_do_application/constants.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';

///Widget that allowed me to have a fully customizable App Bar at the top of the screens
class CustomDrawer extends StatelessWidget {
  static LocalStorage myStorage = LocalStorageHelper().getInstance();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
                 canvasColor: Colors.cyan,//.withOpacity(0.2), //This will change the drawer background to blue.
                 //other styles
              ),
              child: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 150)),
          ListTile(
            title: AutoSizeText(
              'Home',
              // tr('txt_home'),
              style: TextStyle(fontSize: 20, color: Colors.white),
              maxLines: 1,
            ),
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 44,
                maxHeight: 44,
              ),
              child: Icon(Icons.home,  color: Colors.white),
              
            ),
            
            onTap: () {
              Navigator.pushNamed(context, Constants.HOME_SCREEN);
            },
          ),
          
          // Padding(padding: EdgeInsets.only(top: 90)),
          ListTile(
            title: AutoSizeText(
              'Tags',
              // tr('txt_stats'),
              style: TextStyle(fontSize: 20, color: Colors.white),
              maxLines: 1,
            ),
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 44,
                maxHeight: 44,
              ),
              child: Icon(Icons.today_outlined, color: Colors.white),
            ),
            onTap: () {
              Navigator.pushNamed(context, Constants.TAG_SCREEN);
            },
          ),
          // ListTile(
          //   title: AutoSizeText(
          //     'This week',
          //     // tr('txt_stats'),
          //     style: TextStyle(fontSize: 20, color: Colors.white),
          //     maxLines: 1,
          //   ),
          //   leading: ConstrainedBox(
          //     constraints: BoxConstraints(
          //       minWidth: 44,
          //       minHeight: 44,
          //       maxWidth: 44,
          //       maxHeight: 44,
          //     ),
          //     child: Icon(Icons.calendar_today_outlined, color: Colors.white),
          //   ),
          //   onTap: () {
          //     // Navigator.pushNamed(context, '/statistics');
          //   },
          // ),
          // ListTile(
          //   title: AutoSizeText(
          //     'This month',
          //     // tr('txt_stats'),
          //     style: TextStyle(fontSize: 20, color: Colors.white),
          //     maxLines: 1,
          //   ),
          //   leading: ConstrainedBox(
          //     constraints: BoxConstraints(
          //       minWidth: 44,
          //       minHeight: 44,
          //       maxWidth: 44,
          //       maxHeight: 44,
          //     ),
          //     child: Icon(Icons.calendar_today_outlined, color: Colors.white),
          //   ),
          //   onTap: () {
          //     // Navigator.pushNamed(context, '/statistics');
          //   },
          // ),
          // ListTile(
          //   title: AutoSizeText(
          //     'This year',
          //     // tr('txt_stats'),
          //     style: TextStyle(fontSize: 20, color: Colors.white),
          //     maxLines: 1,
          //   ),
          //   leading: ConstrainedBox(
          //     constraints: BoxConstraints(
          //       minWidth: 44,
          //       minHeight: 44,
          //       maxWidth: 44,
          //       maxHeight: 44,
          //     ),
          //     child: Icon(Icons.calendar_today_outlined, color: Colors.white),
          //   ),
          //   onTap: () {
          //     // Navigator.pushNamed(context, '/statistics');
          //   },
          // ),
          // ListTile(
          //   title: AutoSizeText(
          //     'All',
          //     // tr('txt_stats'),
          //     style: TextStyle(fontSize: 20, color: Colors.white),
          //     maxLines: 1,
          //   ),
          //   leading: ConstrainedBox(
          //     constraints: BoxConstraints(
          //       minWidth: 44,
          //       minHeight: 44,
          //       maxWidth: 44,
          //       maxHeight: 44,
          //     ),
          //     child: Icon(Icons.list, color: Colors.white),
          //   ),
          //   onTap: () {
          //     // Navigator.pushNamed(context, '/statistics');
          //   },
          // ),
          Padding(padding: EdgeInsets.only(top: 400)),
          ListTile(
            title: AutoSizeText(
              'Profile',
              // tr('txt_change_language'),
              style: TextStyle(fontSize: 20,  color: Colors.white),
              maxLines: 1,
            ),
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 44,
                maxHeight: 44,
              ),
              child: Icon(Icons.account_circle_outlined,  color: Colors.white),
            ),
            onTap: () {
              Navigator.pushNamed(context, Constants.USER_PROFILE_SCREEN);
              // Navigator.pushNamed(context, '/changeLanguage');
            },
          ),
          ListTile(
            title: AutoSizeText(
              'Log Out',
              // tr('txt_change_language'),
              style: TextStyle(fontSize: 20,  color: Colors.white),
              maxLines: 1,
            ),
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 44,
                minHeight: 44,
                maxWidth: 44,
                maxHeight: 44,
              ),
              child: Icon(Icons.logout,  color: Colors.white),
            ),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(Constants.LOGIN_SCREEN, (Route<dynamic> route) => false);
              // Navigator.pushNamed(context, '/changeLanguage');
            },
          ),
        ],
      )),
    );
  }
}
