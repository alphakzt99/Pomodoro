import 'package:intl/intl.dart';

class Timer {
  int id;
  String title;
  String timer;
  String datetime;
  
  Timer({this.id = 1, this.title = '', this.timer = '', this.datetime = ''}){
    if(datetime.isEmpty){
      datetime = DateFormat.yMMMEd().format(DateTime.now());
    }
  }

  Timer.withID({required this.id, this.title = '', this.timer = '', this.datetime = ''});

  Timer.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 1,
        title = map['title'] ?? '',
        timer = map['timer'] ?? '',
        datetime = map['dateTime'] ?? DateFormat.yMMMEd().format(DateTime.now());
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'timer': timer,
        'dateTime': datetime,
      };
}
