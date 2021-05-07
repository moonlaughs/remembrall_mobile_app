///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';
import 'package:to_do_application/screens_and_widgets/home/home_screen.dart';
import 'package:to_do_application/screens_and_widgets/tasks/task_create.dart';
import 'package:to_do_application/screens_and_widgets/user_profile/user_profile.dart';

///Widgets used in this class
import 'screens_and_widgets/splash_screen/splash_screen.dart';
import 'screens_and_widgets/login_and_register/login.dart';
import 'screens_and_widgets/login_and_register/register.dart';

///The place to call the Splash screen and run the whole app
///initialization also for the localization and DB
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   // visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/loginScreen': (context) => LoginScreen(),
          '/registerScreen': (context) => RegisterScreen(),
          '/homeScreen': (context) => HomeScreen(),
          '/userProfile': (context) => UserProfilePage(),
          '/createTask': (context) => TaskCreateScreen(),
        });
  }
}
