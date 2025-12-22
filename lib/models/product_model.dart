import 'dart:convert';

import 'package:amazon_clone/models/rating_model.dart';

class ProductModel {
  final List<String> images;
  final String productName;
  final String description;
  final double price;
  final double qty;
  final String category;
  final String? id;
  final List<RatingModel>? rating;

  ProductModel({
    required this.images,
    required this.productName,
    required this.description,
    required this.price,
    required this.qty,
    required this.category,
    this.id,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'images': images,
      'productName': productName,
      'description': description,
      'price': price,
      'qty': qty,
      'category': category,
      'id': id,
      "rating": rating,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      images: List<String>.from(map['images'] ?? []),
      productName: map['productName'] ?? "",
      description: map['description'] ?? "",
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      qty: (map['qty'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? "",
      id: map['_id'],
      rating: map['ratings'] != null
          ? List<RatingModel>.from(
              map['ratings'].map((x) => RatingModel.fromMap(x)),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
