import 'package:amazon_clone/common/widgets/rating_star.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class SearchedProduct extends StatelessWidget {
  final ProductModel productModel;
  const SearchedProduct({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    final ratings = productModel.rating ?? [];
    double avgRating = 0.0;
    if (ratings.isNotEmpty) {
      avgRating =
          ratings.fold(0.0, (sum, r) => sum + r.rating) / ratings.length;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height(context) * 0.01,
        horizontal: Dimensions.width(context) * 0.01,
      ),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: Dimensions.width(context) * 0.4,
            decoration: BoxDecoration(color: Colors.white),
            child: Image.network(productModel.images[1], fit: BoxFit.contain),
          ),
          SizedBox(width: Dimensions.width(context) * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productModel.productName,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              SizedBox(height: Dimensions.height(context) * 0.01),
              RatingStar(ratings: avgRating),
              SizedBox(height: Dimensions.height(context) * 0.01),
              Text(
                "\u{20B9}${productModel.price.toString()}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: Dimensions.height(context) * 0.01),
              Text(
                "Eligible for FREE Shipping",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              SizedBox(height: Dimensions.height(context) * 0.01),
              Text(
                "In Stock",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: Dimensions.height(context) * 0.01),
            ],
          ),
        ],
      ),
    );
  }
}
