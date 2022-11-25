import 'package:intl/intl.dart';

class Timer {
  int id = 1;
  String title = '';
  String timer = '';
  String datetime = DateFormat.yMMMEd().format(DateTime.now());
  int get getId => id;

  set setId(int id) => this.id = id;

  String get getTitle => title;

  set getTitle(String title) => this.title = title;

  String get gettimer => timer;

  set settimer(String timer) => this.timer = timer;

  String getDateTime(String dateTime) => datetime = dateTime;
  
  Timer();
  Timer.withID(this.id, this.title, this.timer, this.datetime);

  Timer.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    timer = map['timer'];
    datetime = map['dateTime'];
  }
  Map<String, Object> toMap() => {'id': id, 'title': title, 'timer': timer,'dateTime': datetime};
}
