import 'package:flutter_guid/flutter_guid.dart';

class User {
  String id;
  String username;
  String email;
  String password;

  User({this.id, this.username, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'], 
        username: json['username'],
        email: json['email'],
        password: json['password']);
  }
}