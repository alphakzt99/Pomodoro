import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimerInputBottomSheet extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final AnimationController animationController;
  final Function(Duration,Duration) onTimerDurationChanged;

  const TimerInputBottomSheet({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.animationController,
    required this.onTimerDurationChanged,
  });
  @override
  _TimerInputBottomSheetState createState() => _TimerInputBottomSheetState();
}

class _TimerInputBottomSheetState extends State<TimerInputBottomSheet> {
  late Duration workDuration;
  late Duration restDuration;
  bool changed = false;
  @override
  void initState() {
    super.initState();
    workDuration =
        widget.animationController.duration ?? const Duration(minutes: 25);
    restDuration = const Duration(minutes: 5);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Form(
            key: widget.formKey,
            child: Container(
              width: size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    onTap: () {
                      setState(() {
                        changed = true;
                      });
                    },
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: changed
                        ? InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            labelText: "Title",
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            hintText: "Title",
                            hintStyle: const TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          )
                        : const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            hintText: "Title",
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                    controller: widget.titleController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter the title';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) => widget.titleController.text,
                  ),
                ],
              ),
            ),
          ),
          Text(
            "Choose Work Duration (Max 1 hr)",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: workDuration,
            onTimerDurationChanged: (duration) {
              setState(() {
                workDuration = duration > const Duration(hours: 1)
                    ? const Duration(hours: 1)
                    : duration;
              });
            },
          ),
          Text(
            "Choose Rest Duration (5-10 min)",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.ms,
            initialTimerDuration: restDuration,
            onTimerDurationChanged: (duration) {
              setState(() {
                restDuration = duration < const Duration(minutes: 5)
                    ? const Duration(minutes: 5)
                    : duration > const Duration(minutes: 60)
                        ? const Duration(minutes: 60)
                        : duration;
              });
            },
          ),
          MaterialButton(
            height: 50,
            minWidth: 300,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              if (widget.formKey.currentState!.validate()) {
                widget.onTimerDurationChanged(
                    workDuration, restDuration);
                Navigator.of(context).pop();
              }
            },
            child: Text(
              "Confirm",
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
