import 'dart:async';

///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:to_do_application/screens_and_widgets/home/home_screen.dart';
import 'package:to_do_application/screens_and_widgets/tasks/task_create.dart';
import 'package:to_do_application/screens_and_widgets/tasks/task_update.dart';
import 'package:to_do_application/screens_and_widgets/user_profile/user_profile.dart';

import 'local_storage_helper/local_storage_helper.dart';
///Widgets used in this class
import 'screens_and_widgets/splash_screen/splash_screen.dart';
import 'screens_and_widgets/login_and_register/login.dart';
import 'screens_and_widgets/login_and_register/register.dart';

/// Constant values, that could be used everywhere in the program
import 'constants.dart';

///The place to call the Splash screen and run the whole app
///initialization also for the localization and DB
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  LocalStorage myStorage = LocalStorageHelper().getInstance();
  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(hours: 24), (tick) {
          print('resetting the token');
          myStorage.clear(); //to clear the token          
    });
    return MaterialApp(
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   // visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
        initialRoute: Constants.SPLASH_SCREEN,
        routes: {
          Constants.SPLASH_SCREEN: (context) => SplashScreen(),
          Constants.LOGIN_SCREEN: (context) => LoginScreen(),
          Constants.REGISTER_SCREEN: (context) => RegisterScreen(),
          Constants.HOME_SCREEN: (context) => HomeScreen(),
          Constants.USER_PROFILE_SCREEN: (context) => UserProfilePage(),
          Constants.CREATE_TASK_SCREEN: (context) => TaskCreateScreen(),
          Constants.UPDATE_TASK_SCREEN: (context) => TaskUpdateScreen(),
        });
  }
}
