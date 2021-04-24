///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';

///to have the auto size text
import 'package:auto_size_text/auto_size_text.dart';

///for field validation
import 'package:form_field_validator/form_field_validator.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    double topHeight = MediaQuery.of(context).size.height * (1 / 3);
    double buttonWidth = MediaQuery.of(context).size.width * 0.8;
    double buttonHeight = MediaQuery.of(context).size.height * 0.075;

    GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
                            color: Colors.teal[100],
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * (2 / 3),
                        ),
                        top: MediaQuery.of(context).size.height * (1 / 3),
                      ),
                      new Positioned(
                        child: Image.asset(
                          'assets/logo/todoapptemporarylogo.jpg',
                          scale: 3,
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
                              Navigator.pushNamed(context, '/loginScreen');
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
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Username or Email',
                                    hintText: 'Username or Email'),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "* Required"),

                                  EmailValidator(errorText: "Enter valid email id"), //this should be only used when email
                                ])),
                          ),
                          // TextField(
                          //   decoration: InputDecoration(
                          //       border: OutlineInputBorder(), hintText: 'USERNAME'),
                          // ),
                          top: MediaQuery.of(context).size.height * 0.2 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      new Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            child: TextFormField(
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
                                  MaxLengthValidator(15,
                                      errorText:
                                          "Password should not be greater than 15 characters"),
                                  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                      errorText:
                                          'password must have at least one special character')
                                ])
                                //validatePassword,        //Function to check validation
                                ),
                          ),

                          // TextField(
                          //   decoration: InputDecoration(
                          //       border: OutlineInputBorder(), hintText: 'PASSWORD'),
                          // ),
                          top: MediaQuery.of(context).size.height * 0.3 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                          new Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            child: TextFormField(
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
                                  MaxLengthValidator(15,
                                      errorText:
                                          "Password should not be greater than 15 characters"),
                                  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                      errorText:
                                          'password must have at least one special character')
                                ])
                                //validatePassword,        //Function to check validation
                                ),
                          ),

                          // TextField(
                          //   decoration: InputDecoration(
                          //       border: OutlineInputBorder(), hintText: 'PASSWORD'),
                          // ),
                          top: MediaQuery.of(context).size.height * 0.4 +
                              topHeight,
                          left: MediaQuery.of(context).size.width * 0.1,
                          right: MediaQuery.of(context).size.width * 0.1),
                      new Positioned(
                          child: GestureDetector(
                            onTap: () {
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
                          bottom: MediaQuery.of(context).size.height * 0.06,
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
