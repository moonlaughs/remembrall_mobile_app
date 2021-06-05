class MyTask {
  String id;
  String description;
  String dateTime;
  String location;
  bool done;
  int priority;
  String fkTagId;
  String fkUserId;

  MyTask({this.id, this.description, this.dateTime,this.location, this.done, this.priority, this.fkTagId, this.fkUserId});

  factory MyTask.fromJson(Map<String, dynamic> json) {
    return MyTask(
        id: json['id'], 
        description: json['description'],
        dateTime: json['dateTime'],
        location: json['location'],
        priority: json['priority'],
        done: json['done'],
        fkTagId: json['fkTagId'],
        fkUserId: json['fkUserId'],
        );
  }

  Map<String, dynamic> toJson() => {'id':id, 'description':description, 'dateTime':dateTime,'location': location, 'priority': priority, 'done': done, 'fkTagId': fkTagId, 'fkUserId': fkUserId};
}