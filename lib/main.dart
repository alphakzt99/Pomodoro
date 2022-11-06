import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_ringtone_player/android_sounds.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:pomodoro/database_handler.dart';
import 'package:pomodoro/newPage.dart';
import 'package:pomodoro/timer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro',
      theme: ThemeData(
          primaryColor: Colors.black,
          primaryColorLight: Color(0xFF7AE582),
          primaryColorDark: Colors.white),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Timer timer1 = Timer();
  late final AdvancedDrawerController _advancedDrawerController;
  late AnimationController controller;
  DatabaseHandler databaseHandler = DatabaseHandler();
  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${(controller.duration!.inHours % 60).toString().padLeft(2, '0')}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inHours % 60).toString().padLeft(2, '0')}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  bool isCounting = false;
  notify() {
    if (controller.isDismissed) {
      Alert(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              buttons: [
                DialogButton(
                    radius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Dismiss",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                DialogButton(
                    radius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      databaseHandler.insertData(timer1);
                      Navigator.of(context).pop();
                    })
              ],
              context: context,
              style: AlertStyle(
                  descStyle: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 16,
                  ),
                  titleStyle: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                  backgroundColor: Theme.of(context).primaryColor,
                  alertAlignment: Alignment.topCenter,
                  alertBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              title: "Alert",
              desc: "Pomodoro timer is up.Rest and continue later.")
          .show();
    }
  }

  var key = GlobalKey<FormState>();
  TextEditingController tcontroller = TextEditingController();
  TextEditingController tcontroller1 = TextEditingController();
  double progress = 1.0;
  @override
  void initState() {
    super.initState();

    databaseHandler.initDatabase();
    databaseHandler.initDatabase().whenComplete(() async {
      await databaseHandler.insertData;
      setState(() {});
    });
    _advancedDrawerController = AdvancedDrawerController();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 60));
            timer1.title = tcontroller.text;
    timer1.timer = countText;
    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isCounting = false;
        });
      }
    });
    
    // TODO: implement initState
  }

  @override
  void dispose() {
    _advancedDrawerController.dispose();
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _handleMenuDrawer() {
    _advancedDrawerController.showDrawer();
  }

  bool changed1 = false;
  bool changed = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdvancedDrawer(
        childDecoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        controller: _advancedDrawerController,
        backdropColor: Theme.of(context).primaryColorDark,
        drawer: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          child: ListTileTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            style: ListTileStyle.drawer,
            tileColor: Theme.of(context).primaryColorDark,
            iconColor: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryColor,
            contentPadding:
                const EdgeInsets.only(top: 20, bottom: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).primaryColorLight),
                      image: const DecorationImage(
                          image: AssetImage("lib/photos/KZT.jpg")),
                      borderRadius: BorderRadius.circular(20)),
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "Kaung Zaw Thant\n\n",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: "Level 1",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))
                ])),
                ListTile(
                  onTap: () {},
                  leading: Icon(FluentIcons.person_accounts_24_regular),
                  title: Text("My Account"),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(FluentIcons.history_24_regular),
                  title: Text("Pomodoro List"),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(FluentIcons.settings_24_regular),
                  title: Text("Settings"),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(FluentIcons.contact_card_24_regular),
                  title: Text("Contact Us"),
                ),
              ],
            ),
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  onPressed: _handleMenuDrawer,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: _advancedDrawerController,
                    builder: ((context, value, child) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          value.visible
                              ? Icons.clear
                              : FluentIcons.person_accounts_24_regular,
                          color: Color(0xFF7AE582),
                          key: ValueKey<bool>(value.visible),
                        ),
                      );
                    }),
                  )),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) => newPage()));
                    },
                    icon: Icon(
                      FluentIcons.list_24_regular,
                      size: 24,
                      color: Theme.of(context).primaryColorLight,
                    ))
              ],
            ),
            body: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          color: Theme.of(context).primaryColorLight,
                          value: progress,
                          strokeWidth: 6,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controller.isDismissed) {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                elevation: 10,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                context: context,
                                builder: (context) => SizedBox(
                                      width: size.width,
                                      height: size.height * 0.65,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Form(
                                            key: key,
                                            child: Container(
                                              width: size.width,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    onTap: () {
                                                      setState(() {
                                                        changed1 = true;
                                                      });
                                                    },
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    decoration: changed1 == true
                                                        ? InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            labelText: "ID",
                                                            labelStyle: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            hintText:
                                                                "ID Number",
                                                            hintStyle: const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 16,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          )
                                                        : const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintText:
                                                                "ID Number",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 16,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                    controller: tcontroller1,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Enter the ID Number';
                                                      }
                                                      return null;
                                                    },
                                                    onFieldSubmitted:
                                                        ((value) =>
                                                            tcontroller1.text),
                                                  ),
                                                  TextFormField(
                                                    onTap: () {
                                                      setState(() {
                                                        changed = true;
                                                      });
                                                    },
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    decoration: changed == true
                                                        ? InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            labelText: "Title",
                                                            labelStyle: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            hintText: "Title",
                                                            hintStyle: const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 16,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          )
                                                        : const InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            hintText: "Title",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 16,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                    controller: tcontroller,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Enter the title';
                                                      }
                                                      return null;
                                                    },
                                                    onFieldSubmitted: ((value) {
                                                      tcontroller.text = value;
                                                      timer1.title =
                                                          tcontroller.text;
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Choose your timer",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          CupertinoTimerPicker(
                                            initialTimerDuration:
                                                controller.duration!,
                                            onTimerDurationChanged: (value) {
                                              setState(() {
                                                controller.duration = value;
                                                timer1.timer = countText;
                                              });
                                            },
                                          ),
                                          MaterialButton(
                                            height: 50,
                                            minWidth: 300,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            color:
                                                Theme.of(context).primaryColor,
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              if (key.currentState!
                                                  .validate()) {
                                                return;
                                              }
                                              await databaseHandler
                                                  .insertData(timer1);

                                              Timer timer = Timer.withID(
                                                  int.parse(tcontroller1.text),
                                                  tcontroller.text,
                                                  countText);
                                              int success =
                                                  await databaseHandler
                                                      .insertData(timer1);
                                              if (success == 0) {
                                                print('not successful');
                                              }
                                            },
                                            child: Text(
                                              "Confirm",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ),
                                    ));
                          }
                        },
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) => Text(
                            countText,
                            style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorLight),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                    elevation: 5,
                    height: 50,
                    minWidth: 300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    color: Theme.of(context).primaryColorLight,
                    onPressed: () {
                      if (controller.isAnimating) {
                        controller.stop();
                        setState(() {
                          isCounting = false;
                        });
                      } else {
                        controller.reverse(
                            from:
                                controller.value == 0 ? 1.0 : controller.value);
                        setState(() {
                          isCounting = true;
                        });
                      }
                    },
                    child: isCounting == false
                        ? Text(
                            "Start",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "Stop",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  elevation: 5,
                  height: 50,
                  minWidth: 300,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 2, color: Theme.of(context).primaryColorLight),
                      borderRadius: BorderRadius.circular(20)),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (controller.isAnimating) {
                      controller.reset();
                      setState(() {
                        isCounting = false;
                      });
                    } else {
                      controller.reset();
                      setState(() {
                        isCounting = false;
                      });
                    }
                  },
                  child: Text(
                    "Reset",
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ]),
            )),
      ),
    );
  }
}
