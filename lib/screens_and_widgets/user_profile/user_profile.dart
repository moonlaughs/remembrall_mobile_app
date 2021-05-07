import 'package:auto_size_text/auto_size_text.dart';
///All the pages needs this to work with material wdgets
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _disabled = true;
  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.4;
    double buttonHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left:70.0),
          child: Text("View Profile"),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Container(
        color: Colors.cyan,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height /3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Container(
                      width: 100.0,
                      height: 100.0,
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
              Padding(padding: EdgeInsets.only(top: 8)),
            Text('Jane Doe', style: TextStyle(fontSize: 24, color: Colors.white),),
          ],
        ),
      ),
      Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height / (1.95),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                enabled: !_disabled,
              obscureText: false,
              decoration: InputDecoration(
                labelText: _disabled ? "iza@mial.com" : 'Email',  
                hintText: _disabled ? "iza@mial.com" : "iza@mial.com you can change here",
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true
                  )
                  ),
                   Divider(
                  color: Colors.grey,
                ),
                TextField(
                enabled: !_disabled,
              obscureText: true,
              decoration: InputDecoration(
                labelText: _disabled ? "Password" : 'Password',  
                hintText: _disabled ? "Password" : "Password you can change here",
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true
                  )
                  ),
                   Divider(
                  color: Colors.grey,
                ),
                Padding(padding: EdgeInsets.only(top:20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    GestureDetector(
                  onTap: (){
                    // setState(() {
                    //                       _disabled = !_disabled;
                    //                     });
                  },
                  child: Container(
                              width: buttonWidth,
                              height: buttonHeight,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                color: Colors.red,
                              ),
                              child: Center(
                                child: AutoSizeText('Delete Profile',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    maxLines: 1),
                              ),
                            ),
                ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                                              _disabled = !_disabled;
                                            });
                      },
                      child: Container(
                                  width: buttonWidth,
                                  height: buttonHeight,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100.0)),
                                    color: Colors.teal,
                                  ),
                                  child: Center(
                                    child: AutoSizeText('Update Profile',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        maxLines: 1),
                                  ),
                                ),
                    ),
                    
                  ],
                ),
                // Padding(padding: EdgeInsets.only(top:20)),
                
            ],
          ),
        ),
      )
        ],
      ),
    );
  }
}
