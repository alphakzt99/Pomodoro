import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class newPage extends StatefulWidget {
  const newPage({super.key});

  @override
  State<newPage> createState() => _newPageState();
}

class _newPageState extends State<newPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        style: ListTileStyle.drawer,
        tileColor: Theme.of(context).primaryColorDark,
        iconColor: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
        child: Container(
          width: size.width,
          height: size.height,
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
                ListView.builder(
                    itemBuilder: ((context, index) => ListTile(
                          leading: Icon(
                            FluentIcons.clock_24_regular,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          title: Text("Title"),
                          subtitle: Text("DateTime"),
                        )))
              ]),
        ),
      ),
    );
  }
}
