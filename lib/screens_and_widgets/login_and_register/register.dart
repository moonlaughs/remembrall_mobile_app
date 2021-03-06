import 'dart:convert';
import 'dart:io';

///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';

///to have the auto size text
import 'package:auto_size_text/auto_size_text.dart';

///for field validation
import 'package:form_field_validator/form_field_validator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:to_do_application/Models/token.dart';
import 'package:to_do_application/constants.dart';
import 'package:to_do_application/local_storage_helper/local_storage_helper.dart';
// import 'package:to_do_application/Models/user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final myUserNameController = TextEditingController();
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();
  final myConfirmPasswordController = TextEditingController();
  Uri url = Uri.https('10.0.2.2:5001', '/users');
  HttpClient client = new HttpClient();
  LocalStorage myStorage = LocalStorageHelper().getInstance();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myUserNameController.dispose();
    myPasswordController.dispose();
    myConfirmPasswordController.dispose();
    myEmailController.dispose();
    super.dispose();
  }

  // Future<User>
  register(BuildContext context) async {
    try {
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      String myLogin = myUserNameController.text;
      String myEmail = myEmailController.text;
      String myPass = myPasswordController.text;
      String myConfPass = myConfirmPasswordController.text;
      Map map;
      if (myLogin == null ||
          myEmail == null ||
          myPass == null ||
          myConfPass == null) {
        _showDialog(context,
            'Please fill up required information in order to register');
      } else {
        if (myPass == myConfPass) {
          print('passwords match');
          if (myEmail.contains('@')) {
            print('email contains @');
            map = {"username": myLogin, "email": myEmail, "password": myPass};
            HttpClientRequest request = await client.postUrl(url);

            request.headers.set('content-type', 'application/json');

            request.add(utf8.encode(json.encode(map)));

            HttpClientResponse response = await request.close();
            String reply = await response.transform(utf8.decoder).join();

            if (response.statusCode == 201 || response.statusCode == 200) {
              print('status code: ${response.statusCode}');
              print(reply);

// String receivedString = await response.transform(utf8.decoder).join();

              // var myJson = json.decode(reply);

              // Token myToken = Token.fromJson(myJson);
              // print('created: ' + myToken.createdToken);

              // myStorage.setItem('token', myToken.createdToken);
              // print('saved: ' + myStorage.getItem('token'));
              Navigator.pushNamed(context, Constants.LOGIN_SCREEN);
            } else {
              print('status code: ${response.statusCode}');
              print(reply);
              // "You can only use letters and numbers!" => username and between 3 and 30
              // "The password should contain at least one letter and one number!" => and between 6 and 100
              _showDialog(context,
                  'Something went wrong, password needs to contain at least one letter and number. Or this account already exist.');
            }
          } else {
            _showDialog(context, 'Invalid email address');
          }
        } else {
          _showDialog(context, 'Passwords do not match');
        }
      }
    } catch (e) {
      print(e);
      _showDialog(context,
          'Something went wrong, please check your network connection');
    }
  }

  Future<void> _showDialog(BuildContext context, String dialogMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(dialogMessage),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Ok"),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double topHeight = MediaQuery.of(context).size.height * (1 / 3);
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;
    double buttonHeight = MediaQuery.of(context).size.height * 0.075;

    // GlobalKey<FormState> formkey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // key: formkey,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.cyan,
                        Colors.indigo,
                      ],
                      tileMode: TileMode.mirror)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Center(
                  //   child: Image.asset('assets/logo/todoapptemporarylogo.jpg', scale: 3,),
                  // ),
                  Stack(
                    children: [
                      new Container(
                        width: MediaQuery.of(context).size.width,
                        height:
                            MediaQuery.of(context).size.height, // * (2 / 3),
                      ),
                      new Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50.0),
                                topLeft: Radius.circular(50.0)),
                            color: Colors.white
                                .withOpacity(0.5), //Colors.teal[100],
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * (2 / 3),
                        ),
                        top: MediaQuery.of(context).size.height * (1 / 3),
                      ),
                      new Positioned(
                        child: Image.asset(
                          'assets/otherImages/girl.png',
                          // scale: 3,
                        ),
                        bottom: MediaQuery.of(context).size.height * (2 / 3),
                        left: MediaQuery.of(context).size.width * 0.3,
                        // right: MediaQuery.of(context).size.width * 0.05
                      ),
                      new Positioned(
                          child: AutoSizeText('CREATE AN ACCOUNT',
                              style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                              maxLines: 1),
                          top: MediaQuery.of(context).size.height * 0.06 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.05),
                      new Positioned(
                          child: AutoSizeText("Already have an account?",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                              maxLines: 1),
                          top: MediaQuery.of(context).size.height * 0.12 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.05),
                      new Positioned(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Constants.LOGIN_SCREEN);
                            },
                            child: AutoSizeText('Log in',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                                maxLines: 1),
                          ),
                          top: MediaQuery.of(context).size.height * 0.12 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.7,
                          right: MediaQuery.of(context).size.width * 0.05),
                      new Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5, bottom: 0),
                            child: TextFormField(
                                controller: myUserNameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Username',
                                    hintText: 'Username'),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),
                                  PatternValidator(r'(^(?:.*[A-Za-z0-9])$)',
                                      errorText:
                                          'only and minimum one of letters and numbers')

                                  // EmailValidator(errorText: "Enter valid email id"), //this should be only used when email
                                ])),
                          ),
                          // TextField(
                          //   decoration: InputDecoration(
                          //       border: OutlineInputBorder(), hintText: 'USERNAME'),
                          // ),
                          top: MediaQuery.of(context).size.height * 0.15 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      new Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5, bottom: 0),
                            child: TextFormField(
                                controller: myEmailController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    hintText: 'Email'),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),

                                  EmailValidator(
                                      errorText:
                                          "Enter valid email id"), //this should be only used when email
                                ])),
                          ),
                          // TextField(
                          //   decoration: InputDecoration(
                          //       border: OutlineInputBorder(), hintText: 'USERNAME'),
                          // ),
                          top: MediaQuery.of(context).size.height * 0.25 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      new Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5, bottom: 0),
                            child: TextFormField(
                                controller: myPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    hintText: 'Password'),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),
                                  MinLengthValidator(6,
                                      errorText:
                                          "Password should be atleast 6 characters"),
                                  MaxLengthValidator(40,
                                      errorText:
                                          "Password should not be greater than 30 characters"),
                                  // PatternValidator(r'(^(?:.*[A-Za-z0-9])$)',
                                  //     errorText:
                                  //         'must contain at least one letter and one number')
                                  // needs to have at least one letter and one number
                                  // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                  //     errorText:
                                  //         'password must have at least one special character')
                                ])
                                //validatePassword,        //Function to check validation
                                ),
                          ),

                          // TextField(
                          //   decoration: InputDecoration(
                          //       border: OutlineInputBorder(), hintText: 'PASSWORD'),
                          // ),
                          top: MediaQuery.of(context).size.height * 0.35 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      new Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 5, bottom: 0),
                            child: TextFormField(
                                controller: myConfirmPasswordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirm Password',
                                    hintText: 'Confirm Password'),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),
                                  MinLengthValidator(6,
                                      errorText:
                                          "Password should be atleast 6 characters"),
                                  MaxLengthValidator(40,
                                      errorText:
                                          "Password should not be greater than 30 characters"),
                                  // PatternValidator(r'(^(?:.*[A-Za-z0-9])$)',
                                  //     errorText:
                                  //         'must contain at least one letter and one number')
                                  // MinLengthValidator(6,
                                  //     errorText:
                                  //         "Password should be atleast 6 characters"),
                                  // MaxLengthValidator(15,
                                  //     errorText:
                                  //         "Password should not be greater than 15 characters"),
                                  // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                  //     errorText:
                                  //         'password must have at least one special character')
                                ])
                                //validatePassword,        //Function to check validation
                                ),
                          ),

                          // TextField(
                          //   decoration: InputDecoration(
                          //       border: OutlineInputBorder(), hintText: 'PASSWORD'),
                          // ),
                          top: MediaQuery.of(context).size.height * 0.45 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      new Positioned(
                          child: GestureDetector(
                            onTap: () {
                              register(context);
                              // GlobalKey<FormState> formkey = GlobalKey<FormState>();
                              // if (this.formKey.currentState.validate()) {
                              //   print("Validated");
                              // } else {
                              //   print("Not Validated");
                              // }
                            },
                            child: Container(
                              width: buttonWidth,
                              height: buttonHeight,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                color: Colors.teal[800],
                              ),
                              child: Center(
                                child: AutoSizeText('REGISTER',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    maxLines: 1),
                              ),
                            ),
                          ),
                          bottom: MediaQuery.of(context).size.height * 0.05,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
