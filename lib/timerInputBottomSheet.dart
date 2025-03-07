
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TimerInputBottomSheet extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final AnimationController animationController;
  final Function(Duration) onTimerDurationChanged;

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
  late Duration duration;
  bool changed = false;
  @override
  void initState() {
    super.initState();
    duration = widget.animationController.duration ?? const Duration(seconds: 0);
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.55,
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
            "Choose your timer",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          CupertinoTimerPicker(
            initialTimerDuration: widget.animationController.duration!,
            onTimerDurationChanged: (duration) {
              widget.animationController.duration = duration;
            },
          ),
          MaterialButton(
            height: 50,
            minWidth: 300,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Theme.of(context).primaryColor,
            onPressed: () async{
              if (widget.formKey.currentState!.validate()) {
                widget.onTimerDurationChanged(widget.animationController.duration!);
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
