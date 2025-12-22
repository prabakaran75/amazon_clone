import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/cart/services/cart_services.dart';
import 'package:amazon_clone/features/productDetails/services/product_detail_sercive.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailSercive productDetailSercive = ProductDetailSercive();
  final CartServices cartServices = CartServices();

  void increaseQty(ProductModel product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("x-auth-token")!;

    final updatedCart = await productDetailSercive.addToCart(
      productId: product.id!,
      token: token,
    );

    if (!mounted) return;

    final userProvider = context.read<UserProvider>();

    final updatedUser = userProvider.user.copyWith(cart: updatedCart);

    userProvider.setUserFromModel(updatedUser);
  }

  void removeFromCart(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("x-auth-token")!;

    final updatedCart = await cartServices.removeFromCart(
      productId: product.id!,
      token: token,
    );

    if (!mounted) return;

    final userProvider = context.read<UserProvider>();

    final updatedUser = userProvider.user.copyWith(cart: updatedCart);

    userProvider.setUserFromModel(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = ProductModel.fromMap(productCart['product']);
    final qty = productCart['quantity'];
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height(context) * 0.01,
        horizontal: Dimensions.width(context) * 0.01,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: Dimensions.width(context) * 0.4,
                child: Image.network(product.images[0], fit: BoxFit.cover),
              ),
              SizedBox(width: Dimensions.width(context) * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: Dimensions.height(context) * 0.01),
                    Text(
                      "\u{20B9}${product.price.toString()}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
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
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1.5),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => removeFromCart(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(Icons.remove, size: 18),
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                      ),
                      alignment: Alignment.center,
                      child: Text(qty.toString()),
                    ),
                    InkWell(
                      onTap: () => increaseQty(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(Icons.add, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
