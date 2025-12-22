import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/home/screens/category_screen.dart';
import 'package:flutter/material.dart';

class TopCategories extends StatelessWidget {
  const TopCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.height(context) * 0.17,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: GlobalVariables.categoryImages.length,
        itemBuilder: (context, index) {
          final item = GlobalVariables.categoryImages[index];
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width(context) * 0.015,
              vertical: Dimensions.height(context) * 0.01,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  CategoryScreen.routeName,
                  arguments: item['title'],
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      item["image"]!,
                      fit: BoxFit.cover,
                      width: Dimensions.width(context) * 0.16,
                      height: Dimensions.height(context) * 0.086,
                    ),
                  ),
                  // SizedBox(height: Dimensions.height(context) * 0.01),
                  Text(
                    item["title"]!,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
