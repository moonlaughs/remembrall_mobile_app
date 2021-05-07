import 'package:flutter_guid/flutter_guid.dart';

class Tag {
  Guid id;
  String tagName;
  String tagColor;

  Tag({this.id, this.tagName, this.tagColor,});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
        id: json['id'], 
        tagName: json['tagName'],
        tagColor: json['tagColor']);
  }
}