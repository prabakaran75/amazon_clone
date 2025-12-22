import 'package:amazon_clone/models/cart_product_model.dart';

class CartItemModel {
  final CartProductModel product;
  final int quantity;

  CartItemModel({required this.product, required this.quantity});

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: CartProductModel.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'product': product.toMap(), 'quantity': quantity};
  }
}
