import 'package:amazon_clone/constant/global_variables.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onpress;
  final Color? color;
  final double ht;
  const CustomButton({
    super.key,
    required this.text,
    required this.onpress,
    this.color = GlobalVariables.secondaryColor,
    this.ht = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, ht),
        backgroundColor: color,
        foregroundColor: GlobalVariables.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: onpress,
      child: Text(text),
    );
  }
}
