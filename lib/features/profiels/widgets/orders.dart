import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/orderDetails/screens/order_details_screen.dart';
import 'package:amazon_clone/features/profiels/services/profile_services.dart';
import 'package:amazon_clone/features/profiels/widgets/signle_product_structure.dart';
import 'package:amazon_clone/models/order_models.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final ProfileServices profileServices = ProfileServices();
  List<OrderModels>? orderList;

  void fetchOrders() async {
    orderList = await profileServices.fetchAllTheOrders();
    setState(() {});
  }

  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return orderList == null
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width(context) * 0.02,
              vertical: Dimensions.height(context) * 0.01,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Text(
                        "Your Orders",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "see all",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height(context) * 0.01),
                Container(
                  height: Dimensions.height(context) * 0.24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: orderList!.length,
                    itemBuilder: (context, index) {
                      final image = orderList![index].products[0].images[0];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            OrderDetailsScreen.routeName,
                            arguments: orderList![index],
                          );
                        },
                        child: SignleProductStructure(image: image),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}

//  final List imageList = [
//     "https://www.helpingindia.com/images/asus3.jpeg",
//     "https://gazielectronics.com.bd/wp-content/uploads/2025/10/apple-iphone-17-pro-max-back-camera-side-image-300x300.webp",
//     "https://5.imimg.com/data5/ZY/NG/XZ/ANDROID-74147781/product-jpeg.jpg",
//     "https://cdn.jiostore.online/v2/jmd-asp/jdprod/wrkr/products/pictures/item/free/resize-w:460/mVI8G-6-9s-realme-s2-smartwatch-494492931-i-8-1200wx1200h.jpeg",
//   ];
