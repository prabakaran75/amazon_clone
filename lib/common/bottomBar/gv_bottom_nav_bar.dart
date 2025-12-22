import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/cart/screens/cart_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/features/profiels/screens/profile_screen.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class GvBottomNavBar extends StatefulWidget {
  static const String routeName = "/actual-home";
  const GvBottomNavBar({super.key});

  @override
  State<GvBottomNavBar> createState() => _GvBottomNavBarState();
}

class _GvBottomNavBarState extends State<GvBottomNavBar> {
  int index = 0;
  final List<Widget> screens = [HomeScreen(), ProfileScreen(), CartScreen()];
  int? badgeCount = 2;
  @override
  Widget build(BuildContext context) {
    final wd = MediaQuery.of(context).size.width;
    final ht = MediaQuery.of(context).size.height;
    final userCartLenth = context.watch<UserProvider>().user.cart.length;
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Container(
        color: GlobalVariables.selectedNavBarColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: wd * 0.02,
            vertical: ht * 0.01,
          ),
          child: GNav(
            backgroundColor: GlobalVariables.selectedNavBarColor,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.cyan[700]!,
            // tabBackgroundColor: Color.fromARGB(255, 29, 201, 192),
            // tabBackgroundColor: Colors.lightBlueAccent.shade700,
            gap: wd * 0.01,
            padding: EdgeInsets.symmetric(
              horizontal: wd * 0.03,
              vertical: ht * 0.02,
            ),
            tabs: [
              GButton(icon: Icons.home_outlined, text: "Home"),
              GButton(icon: Icons.person_outline, text: "Profile"),
              GButton(
                icon: Icons.shopping_cart_outlined,
                text: "Cart",
                leading: Badge(
                  isLabelVisible: userCartLenth > 0,
                  label: Text(userCartLenth.toString()),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
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
