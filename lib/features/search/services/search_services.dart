import 'dart:convert';

import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchServices {
  Future<List<ProductModel>> fetchSearchProduct({
    required String productName,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("x-auth-token");

      final res = await http.get(
        Uri.parse("$uri/api/products/search/$productName"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );

      if (res.statusCode == 200) {
        final List productList = jsonDecode(res.body);
        return productList.map((e) => ProductModel.fromMap(e)).toList();
      } else {
        throw Exception("Failed to Load the product");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
