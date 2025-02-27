import 'package:firebase_core/firebase_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/database_handler.dart';
import 'package:pomodoro/firebase_options.dart';
import 'package:pomodoro/newPage.dart';
import 'package:pomodoro/timer.dart';
import 'package:pomodoro/timerCount.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro',
      theme: ThemeData(
          primaryColor: Colors.black,
          primaryColorLight: const Color(0xFF7AE582),
          primaryColorDark: Colors.white),
      home: MyHomePage(
        timer: Timer(),
        context1: context,
      ),
      routes: {"/TimePage": (context) => const newPage()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Timer timer;
  final BuildContext context1;
  const MyHomePage({super.key, required this.timer, required this.context1});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Timer timer1 = Timer();
  late AdvancedDrawerController _advancedDrawerController;
  late AnimationController controller;
  DatabaseHandler databaseHandler = DatabaseHandler();
  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${(controller.duration!.inHours % 60).toString().padLeft(2, '0')}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inHours % 60).toString().padLeft(2, '0')}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  TextEditingController tcontroller = TextEditingController();
  TextEditingController tcontroller1 = TextEditingController();

  bool isCounting = false;

  var key = GlobalKey<FormState>();
  bool looping = true;
  double progress = 1.0;
  @override
  void initState() {
    super.initState();

    _advancedDrawerController = AdvancedDrawerController();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 60));

    controller.addListener(() {
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
      if (controller.isDismissed) {
        FlutterRingtonePlayer().play(
            android: AndroidSounds.notification,
            ios: IosSounds.glass,
            volume: 0.1,
            looping: looping);
      }
      if (controller.isDismissed) {
        Alert(
                context: context,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                      onPressed: () async {
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
                      onPressed: () async {
                        looping = false;
                        FlutterRingtonePlayer().stop();
                        Timer time = Timer.withID(
                            int.parse(tcontroller1.text),
                            tcontroller.text,
                            countText,
                            DateFormat.yMMMEd().format(DateTime.now()));
                        await databaseHandler.insertData(time);
                        setState(() {});
                        Navigator.of(context).pop();
                      })
                ],
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
    });

    // TODO: implement initState
  }

  @override
  void dispose() {
    tcontroller.dispose();
    tcontroller1.dispose();
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

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: AdvancedDrawer(
          childDecoration:
              BoxDecoration(borderRadius: BorderRadius.circular(20)),
          controller: _advancedDrawerController,
          backdropColor: Theme.of(context).primaryColorDark,
          drawer: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            width: size.width * 0.6,
            height: size.height * 0.9,
            child: ListTileTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
                    const TextSpan(
                        text: "Level 1",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ])),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(FluentIcons.person_accounts_24_regular),
                    title: const Text(
                      "My Account",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _advancedDrawerController.hideDrawer();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: ((context) => const TimeCount())));
                    },
                    leading: const Icon(FluentIcons.history_24_regular),
                    title: const Text("Pomodoro List",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(FluentIcons.settings_24_regular),
                    title: const Text("Settings",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(FluentIcons.contact_card_24_regular),
                    title: const Text("Contact Us",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
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
                          color: const Color(0xFF7AE582),
                          key: ValueKey<bool>(value.visible),
                        ),
                      );
                    }),
                  )),
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        "/TimePage",
                      );
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
                                              padding: const EdgeInsets.all(10),
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
                                              if (!key.currentState!
                                                  .validate()) {
                                                return;
                                              }

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
                const SizedBox(
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
                const SizedBox(
                  height: 20,
                )
              ]),
            ),
          ),
        ));
  }
}
