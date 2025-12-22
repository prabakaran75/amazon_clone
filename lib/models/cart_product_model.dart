class CartProductModel {
  final String id;
  final String productName;
  final double price;
  final List<String> images;

  CartProductModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.images,
  });

  factory CartProductModel.fromMap(Map<String, dynamic> map) {
    return CartProductModel(
      id: map['_id'] ?? "",
      productName: map['productName'] ?? "",
      price: (map['price'] as num?)?.toDouble() ?? 0,
      images: List<String>.from(map['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'productName': productName,
      'price': price,
      'images': images,
    };
  }
}
