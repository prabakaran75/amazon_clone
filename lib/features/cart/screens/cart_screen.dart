import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/cart/widgets/cart_product.dart';
import 'package:amazon_clone/features/cart/widgets/cart_subtotal.dart';
import 'package:amazon_clone/features/cart/widgets/custom_cart_app_bar.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height(context) * 0.15),
        child: CustomCartAppBar(user: user),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width(context) * 0.03,
          vertical: Dimensions.height(context) * 0.02,
        ),
        children: [
          CartSubtotal(),
          SizedBox(height: Dimensions.height(context) * 0.02),
          CustomButton(
            text: "Proceed to Buy (${user.cart.length} Items)",
            onpress: () {
              Navigator.pushNamed(
                context,
                AddressScreen.routeName,
                arguments: sum.toString(),
              );
            },
            color: Colors.amber[400],
          ),
          SizedBox(height: Dimensions.height(context) * 0.02),
          ...List.generate(
            user.cart.length,
            (index) => CartProduct(index: index),
          ),
          // ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: user.cart.length,
          //   itemBuilder: (context, index) {
          //     return CartProduct(index: index);
          //   },
          // ),
        ],
      ),
    );
  }
}
