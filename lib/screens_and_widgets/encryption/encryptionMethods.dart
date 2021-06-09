import 'package:encrypt/encrypt.dart';
class EncryptionMethods{
  encrypt(){
    //  final plainText = '"key":"secret_value"';
     final plainText = 'Izabela';
  final key = Key.fromUtf8('b14ca5898a4e4133bbce2ea2315a1916');
  // final iv = IV.fromLength(16);
  final iv = IV.fromUtf8('e16ce913a20dadb8');

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
  print(encrypted.base64); // R4PxiU3h8YoIRqVowBXm36ZcCeNeZ4s1OvVBTfFlZRdmohQqOpPQqD1YecJeZMAop/hZ4OxqgC1WtwvX/hP9mw==
  }
}