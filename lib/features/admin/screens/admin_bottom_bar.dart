import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/analytics_screen.dart';
import 'package:amazon_clone/features/admin/screens/order_screen.dart';
import 'package:amazon_clone/features/admin/screens/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminBottomBar extends StatefulWidget {
  static const String routeName = "/admin-home";
  const AdminBottomBar({super.key});

  @override
  State<AdminBottomBar> createState() => _AdminBottomBarState();
}

class _AdminBottomBarState extends State<AdminBottomBar> {
  int index = 0;
  final List<Widget> screens = [PostScreen(), AnalyticsScreen(), OrderScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Container(
        color: GlobalVariables.selectedNavBarColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width(context) * 0.02,
            vertical: Dimensions.height(context) * 0.01,
          ),
          child: GNav(
            backgroundColor: GlobalVariables.selectedNavBarColor,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.cyan[700]!,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width(context) * 0.03,
              vertical: Dimensions.height(context) * 0.02,
            ),
            gap: Dimensions.width(context) * 0.01,
            tabs: [
              GButton(icon: Icons.home_outlined, text: "Post"),
              GButton(icon: Icons.analytics, text: "Analytics"),
              GButton(icon: Icons.all_inbox_outlined, text: "Orders"),
            ],
            onTabChange: (val) {
              setState(() {
                index = val;
              });
            },
          ),
        ),
      ),
    );
  }
}
