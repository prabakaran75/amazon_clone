import 'package:amazon_clone/features/profiels/widgets/profile_custom_app_bar.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/profiels/widgets/orders.dart';
import 'package:amazon_clone/features/profiels/widgets/top_buttons.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Dimensions.height(context) * 0.12),
          child: ProfileCustomAppBar(user: user),
        ),
        body: SingleChildScrollView(
          child: Column(children: [TopButtons(), Orders()]),
        ),
      ),
    );
  }
}
