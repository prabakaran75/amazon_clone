import 'dart:convert';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailSercive {
  void ratingProduct({
    required ProductModel product,
    required double rating,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("x-auth-token");

      await http.post(
        Uri.parse("$uri/api/product-ratings"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
        body: jsonEncode({"id": product.id, "rating": rating}),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> addToCart({
    required String productId,
    required String token,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$uri/api/add-to-cart"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
        body: jsonEncode({"id": productId}),
      );
      if (res.statusCode != 200) throw Exception("Cart update failed");
      return jsonDecode(res.body);
    } catch (e) {
      print("Add to cart error: $e");
      throw Exception(e.toString());
    }
  }
}


      // List updatedCart = jsonDecode(res.body);
      // UserModel user = userProvider.user.copyWith(cart: updatedCart);
      // userProvider.setUserFromModel(user);
