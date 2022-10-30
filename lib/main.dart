import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_ringtone_player/android_sounds.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:pomodoro/newPage.dart';
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
  late AnimationController controller;
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
              buttons: [
            DialogButton(
                radius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Dismiss",
                  style: TextStyle(fontSize:16,color: Theme.of(context).primaryColorLight,fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            DialogButton(
              radius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Snooze",
                  style: TextStyle(fontSize:16,color: Theme.of(context).primaryColorLight,fontWeight: FontWeight.bold),
                ),
                onPressed: () {
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

  double progress = 1.0;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
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
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdvancedDrawer(
        drawer: Container(),
        child: Scaffold(
            
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) => newPage()));
                    },
                    icon: Icon(FluentIcons.list_24_regular,size: 24,color: Theme.of(context).primaryColorLight,))
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
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                elevation: 10,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                context: context,
                                builder: (context) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Choose your timer",
                                          style: TextStyle(
                                              color:
                                                  Theme.of(context).primaryColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        CupertinoTimerPicker(
                                          initialTimerDuration:
                                              controller.duration!,
                                          onTimerDurationChanged: (value) {
                                            setState(() {
                                              controller.duration = value;
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
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Confirm",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColorDark,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
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
                            from: controller.value == 0 ? 1.0 : controller.value);
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
