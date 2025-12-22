import 'package:amazon_clone/constant/global_variables.dart';
import 'package:flutter/material.dart';

class AddressCustomAppBar extends StatefulWidget {
  const AddressCustomAppBar({super.key});

  @override
  State<AddressCustomAppBar> createState() => _AddressCustomAppBarState();
}

class _AddressCustomAppBarState extends State<AddressCustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios, size: 18),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
      ),
      title: null,
    );
  }
}
