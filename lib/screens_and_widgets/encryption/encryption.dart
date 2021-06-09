

import 'package:flutter/material.dart';
import 'package:to_do_application/screens_and_widgets/encryption/encryptionMethods.dart';
class EncryptionScreen extends StatefulWidget {
  // const EncryptionScreen({ Key? key }) : super(key: key);

  @override
  _EncryptionScreenState createState() => _EncryptionScreenState();
}

class _EncryptionScreenState extends State<EncryptionScreen> {
  EncryptionMethods em = EncryptionMethods();
  @override
  Widget build(BuildContext context) {
    em.encrypt();
    return Scaffold(
      body: Container(
        width: 50,
        height: 50

      )
    );
  }

  
}