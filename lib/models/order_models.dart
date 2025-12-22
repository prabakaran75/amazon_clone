// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:amazon_clone/models/product_model.dart';

class OrderModels {
  final String id;
  final List<ProductModel> products;
  final List<int> quantities;
  final double totalPrice;
  final String address;
  final String userId;
  final int orderedAt;
  final int status;

  OrderModels({
    required this.id,
    required this.products,
    required this.quantities,
    required this.totalPrice,
    required this.address,
    required this.userId,
    required this.orderedAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'products': List.generate(
        products.length,
        (index) => {
          'product': products[index].toMap(),
          'quantity': quantities[index],
        },
      ),
      'totalPrice': totalPrice,
      'address': address,
      'userId': userId,
      'orderedAt': orderedAt,
      'status': status,
    };
  }

  factory OrderModels.fromMap(Map<String, dynamic> map) {
    final List<ProductModel> products = [];
    final List<int> quantities = [];

    for (final item in map['products']) {
      products.add(
        ProductModel.fromMap(item['product'] as Map<String, dynamic>),
      );
      quantities.add(item['quantity'] as int);
    }

    return OrderModels(
      id: map['_id'] ?? "",
      products: products,
      quantities: quantities,
      totalPrice: (map['totalPrice'] as num).toDouble(),
      address: map['address'] ?? "",
      userId: map['userId'] ?? "",
      orderedAt: map['orderedAt'] ?? 0,
      status: map['status'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModels.fromJson(String source) =>
      OrderModels.fromMap(json.decode(source) as Map<String, dynamic>);
}
