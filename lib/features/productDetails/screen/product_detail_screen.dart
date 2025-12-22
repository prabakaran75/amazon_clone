import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/productDetails/services/product_detail_sercive.dart';
import 'package:amazon_clone/features/productDetails/widgets/product_custom_app_bar.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/models/rating_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = "/product-details";
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailSercive productDetailSercive = ProductDetailSercive();
  double avgRating = 0;
  double myRating = 0;

  @override
  void initState() {
    super.initState();
    ratings2();
  }

  // void ratings() {
  //   double totalRatings = 0;
  //   final ratingValue = widget.product.rating;
  //   for (int i = 0; i < ratingValue!.length; i++) {
  //     totalRatings += ratingValue[i].rating;
  //     if (ratingValue[i].userId ==
  //         Provider.of<UserProvider>(context, listen: false).user.id) {
  //       myRating = ratingValue[i].rating;
  //     }
  //   }
  //   if (totalRatings != 0) {
  //     avgRating = totalRatings / ratingValue.length;
  //   }
  // }

  void ratings2() {
    final ratings = widget.product.rating ?? [];
    if (ratings.isEmpty) return;

    final userId = Provider.of<UserProvider>(context, listen: false).user.id;

    avgRating = ratings.fold(0.0, (sum, r) => sum + r.rating) / ratings.length;

    final userRating = ratings.firstWhere(
      (r) => r.userId == userId,
      orElse: () => RatingModel(userId: "", rating: 0.0),
    );

    myRating = userRating.rating;
  }

  void addToCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("x-auth-token")!;

    final updatedCart = await productDetailSercive.addToCart(
      productId: widget.product.id!,
      token: token,
    );

    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final updatedUser = userProvider.user.copyWith(cart: updatedCart);

    userProvider.setUserFromModel(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height(context) * 0.08),
        child: ProductCustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width(context) * 0.02,
            vertical: Dimensions.height(context) * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.id!,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  RatingBarIndicator(
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemSize: 15,
                    rating: avgRating,
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: Colors.amber),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height(context) * 0.01),
              Text(
                widget.product.productName,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              SizedBox(height: Dimensions.height(context) * 0.01),
              SizedBox(
                width: double.infinity,
                child: Image.network(widget.product.images[1]),
              ),
              SizedBox(height: Dimensions.height(context) * 0.01),
              RichText(
                text: TextSpan(
                  text: "Deal Price: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "\$${widget.product.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: const Color.fromARGB(255, 134, 32, 32),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height(context) * 0.01),
              Text(widget.product.description),
              SizedBox(height: Dimensions.height(context) * 0.02),
              CustomButton(text: "Buy Now", onpress: () {}),
              SizedBox(height: Dimensions.height(context) * 0.02),
              CustomButton(
                text: "Add To Cart",
                onpress: addToCartData,
                color: const Color.fromARGB(255, 63, 93, 145),
              ),
              SizedBox(height: Dimensions.height(context) * 0.015),
              Text(
                "Rate The Product",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              RatingBar.builder(
                itemSize: 30,
                initialRating: myRating,
                minRating: 1,
                itemCount: 5,
                allowHalfRating: true,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (ratings) {
                  productDetailSercive.ratingProduct(
                    product: widget.product,
                    rating: ratings,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
