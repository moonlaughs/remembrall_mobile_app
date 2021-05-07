import 'package:flutter_guid/flutter_guid.dart';

class Task {
  Guid id;
  String description;
  DateTime date;
  DateTime time;
  String location;
  int priority;
  Guid fkTagId;
  Guid fkUserId;

  Task({this.id, this.description, this.date, this.time, this.location, this.priority, this.fkTagId, this.fkUserId});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
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
}