import 'package:amazon_clone/constant/global_variables.dart';
import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  const ProfileButton({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.width(context) * 0.01,
        ),
        height: Dimensions.height(context) * 0.065,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: OutlinedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPress,
          child: Center(
            child: Text(text, style: TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}
