import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressedAction;

  // final Color buttonColor;
  final String text;

  const CustomButton(
      {super.key,
      required this.onPressedAction,
      // required this.buttonColor,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          // style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
          onPressed: onPressedAction,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
          )),
    );
  }
}
