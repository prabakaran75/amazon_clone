import 'dart:convert';

import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeService {
  Future<List<ProductModel>> fetchCategoryProducts({
    required String category,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      final res = await http.get(
        Uri.parse("$uri/api/products?category=$category"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );

      if (res.statusCode == 200) {
        final List productList = jsonDecode(res.body);
        return productList.map((e) => ProductModel.fromMap(e)).toList();
      } else {
        throw Exception("Failed to load a product");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ProductModel> fetchDealOfDay() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("x-auth-token");

      if (token == null) {
        throw Exception("User not logged in. Token is missing.");
      }

      final res = await http.get(
        Uri.parse("$uri/api/deal-of-day"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );

      if (res.statusCode != 200) {
        final error = jsonDecode(res.body);
        throw Exception(error["msg"] ?? "Something went wrong!");
      }

      final data = jsonDecode(res.body);

      return ProductModel.fromMap(data);
    } catch (e) {
      throw Exception("Failed to fetch deal of the day: ${e.toString()}");
    }
  }
}
