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
      title: 'Pomodoro',
      theme: ThemeData(
        primaryColor: Colors.black,
        primaryColorLight: Color(0xFF7AE582),
      ),
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
  countText() {
    return Duration();
  }

  late AnimationController controller = AnimationController(vsync: this);
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
          )),
    );
  }
}
