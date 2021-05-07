import 'package:flutter_guid/flutter_guid.dart';

class DecodedToken{
  String nameid;
  int nbf;
  int exp;
  int iat;

  DecodedToken({this.nameid, this.nbf, this.exp, this.iat});

  factory DecodedToken.fromJson(Map<String, dynamic> json){
    return DecodedToken(
       nameid: json['nameid'], 
        nbf: json['nbf'],
        exp: json['exp'],
        iat: json['iat']);
  }
}