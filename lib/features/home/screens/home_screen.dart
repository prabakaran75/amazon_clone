import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/home/widgets/carousal_image.dart';
import 'package:amazon_clone/features/home/widgets/deal_of_day.dart';
import 'package:amazon_clone/features/home/widgets/home_custom_app_bar.dart';
import 'package:amazon_clone/features/home/widgets/top_categories.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height(context) * 0.15),
        child: HomeCustomAppBar(user: user),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Dimensions.height(context) * 0.01),
            TopCategories(),
            CarousalImage(),
            DealOfDay(),
          ],
        ),
      ),
    );
  }
}
