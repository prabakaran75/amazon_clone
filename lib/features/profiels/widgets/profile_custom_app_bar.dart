import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileCustomAppBar extends StatelessWidget {
  const ProfileCustomAppBar({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width(context) * 0.01,
          // vertical: Dimensions.height(context) * 0.01,
        ),
        decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Image.asset(
                      "assets/images/amazon_in.png",
                      width: Dimensions.width(context) * 0.3,
                      height: Dimensions.height(context) * 0.05,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.notifications_outlined),
                        iconSize: 20,
                      ),
                      SizedBox(width: Dimensions.width(context) * 0.01),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.search_outlined),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: Dimensions.width(context) * 0.02),
              child: RichText(
                text: TextSpan(
                  text: "Hello! ",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      title: null,
    );
  }
}
