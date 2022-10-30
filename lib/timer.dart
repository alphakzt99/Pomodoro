import 'package:flutter/material.dart';

class Timer {
  late int id;
  late String title;
  late DateTime time;
  late TimeOfDayFormat timeOfDayFormat;
  int get getId => id;

  set setId(int id) => this.id = id;

  String get getTitle => title;

  set setTitle(String title) => this.title = title;

  DateTime get getDateTime => time;

  set setDateTime(DateTime time) => this.time = time;

  TimeOfDayFormat get getTofD => timeOfDayFormat;

  set setTofD(TimeOfDayFormat timeOfDayFormat) =>
      this.timeOfDayFormat = timeOfDayFormat;

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

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'timer': time};
  Timer.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    time = map['timer'];
  }
}
