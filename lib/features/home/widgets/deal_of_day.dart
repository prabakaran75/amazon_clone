import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/home/services/home_service.dart';
import 'package:amazon_clone/features/productDetails/screen/product_detail_screen.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  final HomeService homeService = HomeService();
  ProductModel? products;
  @override
  void initState() {
    getDealOfTheDay();
    super.initState();
  }

  void getDealOfTheDay() async {
    products = await homeService.fetchDealOfDay();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? Center(child: CircularProgressIndicator())
        : GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                ProductDetailScreen.routeName,
                arguments: products,
              );
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height(context) * 0.01,
                    horizontal: Dimensions.width(context) * 0.01,
                  ),
                  child: Text(
                    "Deal Of The Day",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Image.network(
                  products!.images[0],
                  height: Dimensions.height(context) * 0.25,
                  fit: BoxFit.contain,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height(context) * 0.01,
                    horizontal: Dimensions.width(context) * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\u20B9 ${products!.price.toString()}",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        products!.productName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: products!.images
                        .map(
                          (e) => Image.network(
                            e,
                            fit: BoxFit.contain,
                            width: Dimensions.width(context) * 0.3,
                            height: Dimensions.height(context) * 0.1,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.height(context) * 0.01,
                    horizontal: Dimensions.width(context) * 0.01,
                  ),
                  child: Text(
                    "See all deals",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.cyan[800],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
