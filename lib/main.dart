import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String get countText {
    Duration count = controller.duration! * controller.value;
    return controller.isDismissed
        ? '${(controller.duration!.inHours % 24).toString().padLeft(2, '0')}:${(controller.duration!.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration!.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${(count.inHours % 24).toString().padLeft(2, '0')}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;
  late AnimationController controller;
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 60));
    controller.addListener(() {
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
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

    bool isCounting = false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            leading: IconButton(
              onPressed: () {
                Drawer(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Column(children: []),
                );
              },
              icon: Icon(
                Icons.account_circle_outlined,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
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
                              context: context,
                              builder: (context) => CupertinoTimerPicker(
                                    initialTimerDuration: controller.duration!,
                                    onTimerDurationChanged: (value) {
                                      setState(() {
                                        controller.duration = value;
                                      });
                                    },
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
                  minWidth: 100,
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
                          "Start the timer",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Stop the timer",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
              MaterialButton(
                elevation: 5,
                minWidth: 100,
                shape: RoundedRectangleBorder(
                    side:
                        BorderSide(color: Theme.of(context).primaryColorLight),
                    borderRadius: BorderRadius.circular(20)),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (controller.isAnimating) {
                    controller.reset();
                    setState(() {
                      isCounting = false;
                    });
                  }
                },
                child: Text(
                  "Reset the timer",
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          )),
    );
  }
}
