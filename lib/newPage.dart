import 'dart:async';
import 'package:pomodoro/timer.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/database_handler.dart';

class newPage extends StatefulWidget {
  const newPage({super.key});

  @override
  State<newPage> createState() => _newPageState();
}

class _newPageState extends State<newPage> with TickerProviderStateMixin {
  DatabaseHandler handler = DatabaseHandler();
  ScrollController controller = ScrollController();
  Timer timer = Timer();
  final Stream<List<Timer>> _bids = (() {
    late final StreamController<List<Timer>> controller;
    DatabaseHandler handler = DatabaseHandler();
    controller = StreamController<List<Timer>>(
      onListen: () async {
        handler.selectAllTimer().asStream();
      },
    );
    return controller.stream;
  })();
  @override
  void initState() {
    super.initState();
    handler.selectAllTimer();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            FluentIcons.arrow_circle_left_24_regular,
            size: 32,
            color: Theme.of(context).primaryColorLight,
          ),
        ),
      ),
      body: ListTileTheme(
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Theme.of(context).primaryColorDark,
        iconColor: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.only(
          left: 20,
          top: 10,
          bottom: 8,
        ),
        child: Container(
          width: size.width,
          height: size.height * 0.9,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pomodoro List",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<List<Timer>>(
               
                    stream: _bids,
                    builder: ((context, snapshot) {
                      return !snapshot.hasData
                          ? SizedBox(
                              width: size.width * 0.8,
                              height: size.height * 0.7,
                              child: snapshot.connectionState !=
                                      ConnectionState.waiting
                                  ? Center(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              "Loading...",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ]),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: ((context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: ListTile(
                                            key: ValueKey<int>(snapshot.data![index].id),
                                            leading: Icon(
                                              FluentIcons.clock_24_filled,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                            title: Text(
                                              snapshot.data![index].title,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              snapshot.data![index].timer,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        );
                                      })),
                            )
                          : Container(
                              child: Text(
                                "Hello",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                    }))
              ]),
        ),
      ),
    );
  }
}
