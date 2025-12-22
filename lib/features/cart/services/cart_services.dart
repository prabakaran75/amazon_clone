import 'dart:convert';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CartServices {
  Future<List<dynamic>> removeFromCart({
    required String productId,
    required String token,
  }) async {
    try {
      final res = await http.delete(
        Uri.parse("$uri/api/remove-from-cart/$productId"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );
      if (res.statusCode != 200) throw Exception("Cart update failed");
      return jsonDecode(res.body);
    } catch (e) {
      debugPrint("Add to cart error: $e");
      throw Exception(e.toString());
    }
  }
}
