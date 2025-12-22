import 'package:amazon_clone/constant/global_variables.dart';
import 'package:flutter/material.dart';

class AdminCustomAppBar extends StatelessWidget {
  const AdminCustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Image.asset(
              "assets/images/amazon_in.png",
              width: Dimensions.width(context) * 0.3,
              height: Dimensions.height(context) * 0.05,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: Dimensions.width(context) * 0.01),
            child: Text(
              "Admin",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
