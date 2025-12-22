import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/admin/widgets/admin_custom_app_bar.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height(context) * 0.1),
        child: AdminCustomAppBar(),
      ),
    );
  }
}
