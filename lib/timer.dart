import 'package:intl/intl.dart';

class Timer {
  String title;
  String timer;
  String datetime;
  
  Timer({this.title = '', this.timer = '', this.datetime = ''}){
    if(datetime.isEmpty){
      datetime = DateFormat.yMMMEd().format(DateTime.now());
    }
  }


  Timer.fromMap(Map<String, dynamic> map)
      : 
        title = map['title'] ?? '',
        timer = map['timer'] ?? '',
        datetime = map['dateTime'] ?? DateFormat.yMMMEd().format(DateTime.now());
  Map<String, dynamic> toMap() => {
        'title': title,
        'timer': timer,
        'dateTime': datetime,
      };
}
