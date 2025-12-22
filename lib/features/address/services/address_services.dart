import 'dart:convert';

import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/models/order_models.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddressServices {
  Future<UserModel> saveUserAddress({
    required String address,
    required String token,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$uri/api/save-user-address"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
        body: jsonEncode({"address": address}),
      );
      if (res.statusCode == 200) {
        return UserModel.fromJson(res.body);
      } else {
        throw Exception("Failed to save address");
      }
    } catch (e) {
      debugPrint("Add to cart error: $e");
      throw Exception(e.toString());
    }
  }

  Future<OrderModels> placeOrder({
    required List<dynamic> cart,
    required String address,
    required double totalPrice,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("x-auth-token");

      final res = await http.post(
        Uri.parse("$uri/api/order"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
        body: jsonEncode({
          "cart": cart,
          "totalPrice": totalPrice,
          "address": address,
        }),
      );

      if (res.statusCode == 200) {
        return OrderModels.fromJson(res.body);
      } else {
        throw Exception(jsonDecode(res.body)['msg']);
      }
    } catch (e) {
      debugPrint("Add to order error: $e");
      throw Exception(e.toString());
    }
  }
}
