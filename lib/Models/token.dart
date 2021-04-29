class Token {
  String createdToken;

  Token({this.createdToken,});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        createdToken: json['createdToken'],);
  }
}