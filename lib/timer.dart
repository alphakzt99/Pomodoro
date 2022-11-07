
class Timer {
  int id = 1;
  String title = '';
  String timer = '';
  int get getId => id;

  set setId(int id) => this.id = id;

  String get getTitle => title;

  set getTitle(String title) => this.title = title;

  String get gettimer => timer;

  set settimer(String timer) => this.timer = timer;
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
