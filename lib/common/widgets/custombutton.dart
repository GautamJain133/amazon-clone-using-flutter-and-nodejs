import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function ontap;
  final Color? color;

  const CustomButton(
      {Key? key, required this.text, required this.ontap, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        primary: color,
      ),
      onPressed: () {
        ontap();
      },
      child: Text(
        text,
        style: TextStyle(color: color == null ? Colors.white : Colors.black),
      ),
    );
  }
}
