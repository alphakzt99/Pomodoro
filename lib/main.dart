import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:pomodoro/Drawer.dart';
import 'package:pomodoro/database_handler.dart';
import 'package:pomodoro/timePage.dart';
import 'package:pomodoro/timer.dart';
import 'package:pomodoro/timerInputBottomSheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'sign_in.dart';
import 'sign_up.dart';
import 'auth_service.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pomodoro',
          theme: ThemeData(
              primaryColor: Colors.black,
              primaryColorLight: const Color(0xFF7AE582),
              primaryColorDark: Colors.white),
          initialRoute: '/signup',
          routes: {
            '/signup': (context) => SignUpScreen(),
            '/signin': (context) => SignInScreen(),
            '/home': (context) => MyHomePage(
                  timer: Timer(),
                  context1: context,
                ),
            '/timePage': (context) => timePage(),
          },
        );
      },
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
  late AdvancedDrawerController _advancedDrawerController;
  late AnimationController animationController;
  DatabaseHandler databaseHandler = DatabaseHandler();
  String get countText {
    Duration count = animationController.duration! * animationController.value;
    return animationController.isDismissed
        ? '${(animationController.duration!.inHours % 60).toString().padLeft(2, '0')}:${(animationController.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(animationController.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inHours % 60).toString().padLeft(2, '0')}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  TextEditingController titleController = TextEditingController();

  bool isCounting = false;
  bool isWorking = true;
  late Duration workDuration;
  late Duration restDuration;
  var key = GlobalKey<FormState>();
  bool looping = true;
  double progress = 1.0;
  @override
  void initState() {
    super.initState();
    workDuration = const Duration(minutes: 25);
    restDuration = const Duration(minutes: 5);
    _advancedDrawerController = AdvancedDrawerController();
    animationController =
        AnimationController(vsync: this, duration: workDuration)
          ..addListener(() {
            if (animationController.isAnimating) {
              setState(() {
                progress = animationController.value;
              });
            } else {
              setState(() {
                progress = 1.0;
                isCounting = false;
              });
              handlePhase();
            }
          });

    animationController.addStatusListener((status) {
      if (animationController.isDismissed) {
        FlutterRingtonePlayer().play(
            android: AndroidSounds.notification,
            ios: IosSounds.glass,
            volume: 1.0,
            looping: looping);
      }
    });
  }

  void handlePhase() {
    if (animationController.isDismissed) {
      String stageTitle = isWorking ? "Work" : "Rest";
      Alert(
        context: context,
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
              onPressed: () async {
                looping = false;
                FlutterRingtonePlayer().stop();
                Navigator.of(context).pop();
                switchStage();
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
                Timer time = Timer(
                    title: titleController.text,
                    timer: countText,
                    datetime: DateFormat.yMMMEd().format(DateTime.now()));
                await databaseHandler.addTimer(time);
                Navigator.of(context).pop();
                switchStage();
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
        title: "$stageTitle Timer Up",
        desc: isWorking
            ? "Take a break! Rest timer will start next."
            : "Back to work? Work timer will start next.",
      ).show();
    }
  }

  void startTimer() {
    if (!animationController.isAnimating) {
      animationController.reverse(from: 1.0);
      setState(() {
        isCounting = true;
      });
    }
  }

  void switchStage() {
    setState(() {
      isWorking = !isWorking;
      animationController.duration = isWorking ? workDuration : restDuration;
      animationController.reset();
      progress = 1.0;
      isCounting = true;
    });
    startTimer();
  }

  @override
  void dispose() {
    titleController.dispose();
    _advancedDrawerController.dispose();
    animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void handleMenuDrawer() {
    _advancedDrawerController.showDrawer();
  }

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
          drawer:
              DrawerPage(advancedDrawerController: _advancedDrawerController),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                  onPressed: handleMenuDrawer,
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
                        "/timePage",
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
                          if (animationController.isDismissed) {
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
                                builder: (context) => TimerInputBottomSheet(
                                      formKey: key,
                                      titleController: titleController,
                                      animationController: animationController,
                                      onTimerDurationChanged:
                                          (Duration workDuration,
                                              Duration restDuration) {
                                        setState(() {
                                          this.workDuration = workDuration;
                                          this.restDuration = restDuration;
                                          isWorking = true;
                                          animationController.duration =
                                              workDuration;
                                          progress = 1.0;
                                        });
                                      },
                                    ));
                          }
                        },
                        child: AnimatedBuilder(
                          animation: animationController,
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
                      if (animationController.isAnimating) {
                        animationController.stop();
                        setState(() {
                          isCounting = false;
                        });
                      } else {
                        startTimer();
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
                    if (animationController.isAnimating) {
                      animationController.reset();
                      setState(() {
                        isCounting = false;
                        isWorking = true;
                        animationController.duration = workDuration;
                        progress = 1.0;
                      });
                    } else {
                      startTimer();
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
