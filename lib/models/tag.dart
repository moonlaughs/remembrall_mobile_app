import 'package:flutter_guid/flutter_guid.dart';

class Tag {
  String id;
  String tagName;
  String tagColor;

  Tag({this.id, this.tagName, this.tagColor,});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
        id: json['id'], 
        tagName: json['tagName'],
        tagColor: json['tagColor']);
  }

  Map<String, dynamic> toJson() => {'id':id, 'tagName': tagName, 'tagColor':tagColor};

  List<Tag> myTags = [];

  getTags(){
    return myTags;
  }

  setTags(List<Tag> tags){
    myTags = tags;
  }

  // static final Tag _singleton = Tag._internal();
  // factory Tag() {
  //   return _singleton;
  // }

  Tag._internal();
  static Tag _myInstance;

  Tag getInstance(){
    if (_myInstance == null) {
      _myInstance = new Tag();
    }
    return _myInstance;
  }
}