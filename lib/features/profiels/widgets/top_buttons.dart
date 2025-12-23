import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/profiels/services/profile_services.dart';
import 'package:amazon_clone/features/profiels/widgets/profile_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  final profileServices = ProfileServices();

  void signOut() async {
    profileServices.logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AuthScreen.routeName,
      (route) => false,
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                signOut;
              },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: Dimensions.width(context) * 0.02,
        right: Dimensions.width(context) * 0.02,
        top: Dimensions.height(context) * 0.02,
      ),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     ProfileButton(text: "Your Orders", onPress: () {}),
          //     ProfileButton(text: "Turn Seller", onPress: () {}),
          //   ],
          // ),
          // SizedBox(height: Dimensions.height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileButton(
                text: "Log Out",
                onPress: () => showLogoutDialog(context),
              ),
              ProfileButton(text: "Your Wish List", onPress: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
