

class Timer {
  int id = 1;
  String title = '';
  String timer = '';

  Timer();
  Timer.withID(
    this.id,
    this.title,
    this.timer,
  );
  
  Timer.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    timer = map['timer'];
  }
  Map<String, Object> toMap() => {'id': id, 'title': title, 'timer': timer};
}
