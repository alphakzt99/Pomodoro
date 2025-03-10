import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/database_handler.dart';

import 'timer.dart';

class TimeCount extends StatefulWidget {
  const TimeCount({super.key});

  @override
  State<TimeCount> createState() => _TimeCountState();
}

class _TimeCountState extends State<TimeCount> {
  late Future<List<MapEntry<String, Timer>>> _timer;
  late DatabaseHandler handler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    _timer = handler.getTimers();
  }

  Color getColorForFrequency(int frequency) {
    switch (frequency) {
      case 1:
        return Colors.green[100]!;
      case 2:
        return Colors.green[300]!;
      case 3:
        return Theme.of(context).primaryColorLight;
      case 4:
        return Colors.greenAccent[700]!;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            FluentIcons.arrow_left_28_filled,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        elevation: 0,
        title: Text(
          "Frequency",
          style: TextStyle(
              color: Theme.of(context).primaryColorLight,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder(
        future: _timer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.data!.isEmpty) {
            return const Text("No timers found");
          }

          final timers = snapshot.data!;
          final groupedTimers = handler.groupTimersbyMonth(timers);
          final months = groupedTimers.keys.toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Less",
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: size.width * 0.08,
                      height: size.height * 0.04,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: size.width * 0.08,
                      height: size.height * 0.04,
                      color: Colors.green[100],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: size.width * 0.08,
                      height: size.height * 0.04,
                      color: Colors.green[300],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: size.width * 0.08,
                      height: size.height * 0.04,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: size.width * 0.08,
                      height: size.height * 0.04,
                      color: Colors.greenAccent[700],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "More",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: size.width * 0.8,
                  height: size.height * 0.8,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: months.length,
                      itemBuilder: ((context, index) {
                        final month = months[index];
                        Map<int, int> days = groupedTimers[month] ?? {};
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: size.width * 0.01,
                                  top: size.height * 0.03),
                              child: Text(
                                month,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: size.width * 0.8,
                              height: size.height * 0.25,
                              margin: const EdgeInsets.all(10),
                              child: GridView.builder(
                                  reverse: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 28,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 10,
                                          crossAxisCount: 7,
                                          mainAxisSpacing: 10),
                                  itemBuilder: ((context, dayIndex) {
                                    int day = dayIndex + 1;
                                    int frequency = days[day] ?? 0;
                                    return Container(
                                        width: size.width * 0.04,
                                        height: size.height * 0.02,
                                        decoration: BoxDecoration(
                                            color: getColorForFrequency(frequency),
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.005)),
                                      );
                                    })),
                            )
                          ],
                        );
                      })),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
