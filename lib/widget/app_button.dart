import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  String text;
  Function()? onPressed;
  bool showProgress;
  double width;

  AppButton(this.text, {this.onPressed, this.showProgress = false, this.width = 250});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.deepPurple
        ),
        onPressed: onPressed,
        child: showProgress
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}