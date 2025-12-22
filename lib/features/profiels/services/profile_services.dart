import 'dart:convert';

import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/models/order_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileServices {
  Future<List<OrderModels>> fetchAllTheOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("x-auth-token");

      final res = await http.get(
        Uri.parse("$uri/api/user-orders"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );

      if (res.statusCode == 200) {
        final List orderList = jsonDecode(res.body);
        return orderList.map((e) => OrderModels.fromMap(e)).toList();
      } else {
        throw Exception("Failed to fetch user order list");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("x-auth-token", "");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
