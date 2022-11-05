import 'package:flutter/material.dart';

class Timer {
  int id = 1;
  String title = '';
  String time= '';
  
  int get getId => id;

  set setId(int id) => this.id = id;

  String get getTitle => title;

  set setTitle(String title) => this.title = title;

  String get getDateTime => time;

  set setDateTime(String time) => this.time = time;

  
  Timer();
  Timer.withID(
    this.id,
    this.title,
    this.time,
  );
  Timer.withoutID(
    this.title,
    this.time,
  );

  Map<String, dynamic> toMap() => {'title': title, 'timer': time};
  Timer.fromMap(Map<String, dynamic> map) {
  
    title = map['title'];
    time = map['timer'];
  }
}
