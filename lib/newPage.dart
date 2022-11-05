import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/database_handler.dart';
import 'package:sqflite/sqflite.dart';

class newPage extends StatefulWidget {
  const newPage({super.key});

  @override
  State<newPage> createState() => _newPageState();
}

class _newPageState extends State<newPage> with TickerProviderStateMixin {
  late DatabaseHandler handler;
  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
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
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: handler.selectAllbooks(),
                    builder: ((context, snapshot) {
                      return snapshot.connectionState != ConnectionState.done
                          ? Center(
                              child: Column(children: [
                                CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                Text(
                                  "Loading",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                            )
                          : Container(
                              width: size.width * 0.8,
                              height: size.height * 0.7,
                              child: snapshot.data!.isEmpty
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      "lib/photos/error.jpg"))),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "You have no data",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  : ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: ((context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: ListTile(
                                            leading: Icon(
                                              
                                              FluentIcons.clock_24_filled,
                                              color: Theme.of(context).primaryColorLight,
                                            ),
                                            title: Text(
                                              snapshot.data![index].title,
                                              style: TextStyle(
                                                  color: Theme.of(context).primaryColorLight,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                              
                                              snapshot.data![index].time,
                                              style: TextStyle(
                                                color: Theme.of(context).primaryColorLight,
                                                fontSize: 16),
                                            ),
                                          ),
                                        );
                                      })),
                            );
                    }))
              ]),
        ),
      ),
    );
  }
}
