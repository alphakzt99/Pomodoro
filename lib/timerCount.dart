import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class TimeCount extends StatefulWidget {
  const TimeCount({super.key});

  @override
  State<TimeCount> createState() => _TimeCountState();
}

class _TimeCountState extends State<TimeCount> {
  late DatabaseHandler databasehandler;
  @override
  void initState() {
    databasehandler = DatabaseHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List Color = [
      Theme.of(context).primaryColorDark,
      Colors.green[100],
      Colors.green[300],
      Theme.of(context).primaryColorLight,
      Colors.greenAccent[700]
    ];
    colorChange(String snapshot) {
      int total = 0;
      final now = DateTime.now();
      final today =
          DateFormat.yMMMEd().format(DateTime(now.year, now.month, now.day));
      if (snapshot == today) {
        total += 1;
        return total == 0
            ? Color[0]
            : total < 2
                ? Color[1]
                : total < 5
                    ? Color[2]
                    : total < 8
                        ? Color[3]
                        : Color[4];
      }
      return Colors.white;
    }

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
      body: Column(
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
            child: Container(
              width: size.width * 0.8,
              height: size.height * 0.8,
              child: FutureBuilder(
                future: databasehandler.selectAllTimer(),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? HeatMap(
                          textColor: Colors.white,
                          datasets: {
                            DateTime(
                                DateTime.parse(snapshot.data![0].datetime).year,
                                DateTime.parse(snapshot.data![0].datetime)
                                    .month,
                                DateTime.parse(snapshot.data![0].datetime)
                                    .day): 13,
                            DateTime(2022, 11, 9): 1,
                            DateTime(2022, 11, 13): 6,
                          },
                          colorsets: {
                            1: Color[1],
                            2: Color[1],
                            3: Color[2],
                            4: Color[2],
                            5: Color[2],
                            10: Color[3],
                            15: Color[4]
                          },
                          scrollable: true,
                          colorMode: ColorMode.color,
                          defaultColor: Color[0],
                          startDate: DateTime(2022, 10, 10),
                          endDate: DateTime(2022, 12, 31),
                        )
                      : Center(
                          child: Container(child: Text("You have no data")),
                        );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
