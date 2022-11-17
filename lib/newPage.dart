import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:pomodoro/timer.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/database_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class newPage extends StatefulWidget {
  const newPage({super.key});

  @override
  State<newPage> createState() => _newPageState();
}

class _newPageState extends State<newPage> with TickerProviderStateMixin {
  late DatabaseHandler handler;
  ScrollController controller = ScrollController();
  Timer timer = Timer();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
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
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            FluentIcons.arrow_circle_left_24_regular,
            size: 32,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: ListTileTheme(
        style: ListTileStyle.list,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        iconColor: Theme.of(context).primaryColorLight,
        textColor: Theme.of(context).primaryColorLight,
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
                      color: Theme.of(context).primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                FutureBuilder<List<Timer>>(
                    future: handler.selectAllTimer(),
                    builder: ((context, snapshot) {
                      return snapshot.data != 0
                          ? SizedBox(
                              width: size.width * 0.8,
                              height: size.height * 0.7,
                              child: snapshot.connectionState ==
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
                                            const SizedBox(
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
                                      itemBuilder: ((context1, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: SwipeActionCell(
                                            backgroundColor: Colors.white,
                                            key: ValueKey<int>(
                                                snapshot.data![index].id),
                                            trailingActions: [
                                              SwipeAction(
                                                  widthSpace: size.width * 0.3,
                                                  color: Colors.white,
                                                  backgroundRadius: 10,
                                                  content: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: const [
                                                        Icon(
                                                          FluentIcons
                                                              .delete_32_regular,
                                                          color: Colors.red,
                                                        ),
                                                        Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ]),
                                                  onTap: (tap) {
                                                    Alert(
                                                        useRootNavigator: false,
                                                        context: context1,
                                                        title: "Alert",
                                                        desc:
                                                            "Do you want to delete this note?",
                                                        style: AlertStyle(
                                                            backgroundColor:
                                                                Theme.of(context)
                                                                    .primaryColor,
                                                            alertAlignment: Alignment
                                                                .center,
                                                            alertBorder: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        20)),
                                                            descStyle: TextStyle(
                                                                color: Theme.of(context)
                                                                    .primaryColorLight,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight
                                                                    .bold),
                                                            titleStyle: TextStyle(
                                                                color: Theme.of(context)
                                                                    .primaryColorLight,
                                                                fontSize: 24,
                                                                fontWeight: FontWeight
                                                                    .w300)),
                                                        padding: const EdgeInsets.symmetric(
                                                            horizontal: 0,
                                                            vertical: 10),
                                                        buttons: [
                                                          DialogButton(
                                                              color:
                                                                  Colors.black,
                                                              child: Text(
                                                                  "Dismiss",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorLight,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                              onPressed: () {
                                                                setState(() {});
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }),
                                                          DialogButton(
                                                              color:
                                                                  Colors.black,
                                                              child: Text(
                                                                  "Confrim",
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColorLight,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400)),
                                                              onPressed: () {
                                                                handler.deleteData(
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .id);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                setState(() {});
                                                              })
                                                        ]).show();
                                                  })
                                            ],
                                            child: Card(
                                              color: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: ListTile(
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
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  snapshot.data![index].timer,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColorLight,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      })),
                            )
                          : Container(
                              width: size.width * 0.8,
                              height: size.height * 0.7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Image(
                                      width: 200,
                                      height: 200,
                                      image:
                                          AssetImage("lib/photos/error.jpg")),
                                  Text(
                                    "No Data Available",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
}))
              ]),
        ),
      ),
    );
  }
}
