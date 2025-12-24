import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/profiels/services/profile_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminCustomAppBar extends StatefulWidget {
  const AdminCustomAppBar({super.key});

  @override
  State<AdminCustomAppBar> createState() => _AdminCustomAppBarState();
}

class _AdminCustomAppBarState extends State<AdminCustomAppBar> {
  final profileServices = ProfileServices();

  void signOut() async {
    profileServices.logout();
    Provider.of<UserProvider>(context, listen: false).clearUser();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AuthScreen.routeName);
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
                // Close dialog
                Navigator.pop(context);
                signOut();
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
          IconButton(
            onPressed: () => showLogoutDialog(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
