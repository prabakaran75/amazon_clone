import 'package:amazon_clone/constant/global_variables.dart';
import 'package:flutter/material.dart';

class SignleProductStructure extends StatelessWidget {
  final String image;
  const SignleProductStructure({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width(context) * 0.01,
      ),
      child: Container(
        // padding: EdgeInsets.symmetric(
        //   horizontal: Dimensions.width(context) * 0.01,
        //   vertical: Dimensions.height(context) * 0.01,
        // ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.black,
            width: Dimensions.width(context) * 0.003,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: SizedBox(
          width: Dimensions.width(context) * 0.5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              image,
              fit: BoxFit.fitHeight,
              width: Dimensions.width(context) * 0.01,
            ),
          ),
        ),
      ),
    );
  }
}
