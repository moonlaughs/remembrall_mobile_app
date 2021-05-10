// import 'package:flutter_guid/flutter_guid.dart';

class MyTask {
  String id;
  String description;
  String date;
  String time;
  String location;
  int priority;
  String fkTagId;
  String fkUserId;

  MyTask({this.id, this.description, this.date, this.time, this.location, this.priority, this.fkTagId, this.fkUserId});

  factory MyTask.fromJson(Map<String, dynamic> json) {
    return MyTask(
        id: json['id'], 
        description: json['description'],
        date: json['date'],
        time: json['time'],
        location: json['location'],
        priority: json['priority'],
        fkTagId: json['fkTagId'],
        fkUserId: json['fkUserId'],
        );
  }

  Map<String, dynamic> toJson() => {'id':id, 'description':description, 'date':date, 'time': time, 'location': location, 'priority': priority, 'fkTagId': fkTagId, 'fkUserId': fkUserId};
}