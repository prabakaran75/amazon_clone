import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  // static const String routeName = "/actual-home";
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int index = 0;
  List screens = [
    HomeScreen(),
    Center(child: Text("Profile Screen")),
    Center(child: Text("Cart Screen")),
  ];
  @override
  Widget build(BuildContext context) {
    final wd = MediaQuery.of(context).size.width;
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        currentIndex: index,
        selectedItemColor: GlobalVariables.secondaryColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        items: [
          customNavBarItem(
            wd: wd,
            icon: Icons.home_outlined,
            text: "Home",
            itemIndex: 0,
          ),
          customNavBarItem(
            wd: wd,
            icon: Icons.person_outline,
            text: "Profile",
            itemIndex: 1,
          ),
          customNavBarItem(
            wd: wd,
            icon: Icons.shopping_cart_outlined,
            text: "Cart",
            itemIndex: 2,
            badgeCount: 2,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem customNavBarItem({
    required double wd,
    required IconData icon,
    required String text,
    required int itemIndex,
    int? badgeCount,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        width: wd * 0.09,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: index == itemIndex
                  ? GlobalVariables.secondaryColor
                  : GlobalVariables.backgroundColor,
              width: wd * 0.009,
            ),
          ),
        ),
        child: Badge(
          isLabelVisible: badgeCount != null && badgeCount > 0,
          backgroundColor: GlobalVariables.secondaryColor,
          label: Text(badgeCount.toString()),
          child: Icon(icon),
        ),
      ),
      label: text,
    );
  }
}
