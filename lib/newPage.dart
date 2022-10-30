import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class newPage extends StatefulWidget {
  const newPage({super.key});

  @override
  State<newPage> createState() => _newPageState();
}

class _newPageState extends State<newPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> opacityAnimation;
  Tween<double> opacityTween = Tween<double>(begin: 0.0, end: 1.0);
  Tween<double> marginTopTween = Tween<double>(begin: 300, end: 280);
  late Animation<double> marginTopAnimation;
  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    marginTopAnimation = marginTopTween.animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height,
      width: size.width,
      child: CircularCountDownTimer(
        width: 300,
        height: 300,
        fillColor: Colors.black,
        ringColor: Colors.blue,
        onComplete: () {
          Alert(
                  context: this.context,
                  type: AlertType.success,
                  content: Text("Hello"))
              .show();
          AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => AlertDialog(
                    contentPadding: const EdgeInsets.all(10),
                    backgroundColor: Theme.of(context).primaryColorDark,
                    title: const Text(
                      "Alert",
                    ),
                    titleTextStyle: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    content: const Text(
                        "Pomodoro Time is up. Take a rest and continue"),
                    contentTextStyle: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 20,
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actionsPadding: const EdgeInsets.all(10),
                    actions: [
                      TextButton(
                          onPressed: () {
                            _controller.reverse();
                          },
                          child: Text(
                            "Dismiss",
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight),
                          ))
                    ],
                  ).build(context)
                  );
        },
        duration: 20,
      ),
    );
  }
}
