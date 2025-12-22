import 'dart:convert';

import 'package:amazon_clone/constant/erro_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserModel userModel = UserModel(
        id: "",
        name: name,
        email: email,
        password: password,
        address: "",
        type: "",
        token: "",
        cart: [],
      );
      final res = await http.post(
        Uri.parse("$uri/api/signup"),
        body: userModel.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (kDebugMode) {
        print("Signup Status: ${res.statusCode}");
        print("Signup Response: ${res.body}");
      }
      return errorHandling(res);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response> signInUser({
    required String email,
    required String password,
  }) async {
    try {
      UserModel user = UserModel(
        id: "",
        name: "",
        email: email,
        password: password,
        address: "",
        type: "",
        token: "",
        cart: [],
      );
      final res = await http.post(
        Uri.parse("$uri/api/signin"),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      if (kDebugMode) {
        print("Signin Status: ${res.statusCode}");
        print("Signin Response: ${res.body}");
      }
      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<http.Response?> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");
      if (token == null) {
        prefs.setString("x-auth-token", "");
        return null;
      }

      final tokenRes = await http.post(
        Uri.parse("$uri/tokenIsValid"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
      );

      final response = jsonDecode(tokenRes.body);

      if (response == true) {
        final userRes = await http.get(
          Uri.parse("$uri/getUser"),
          headers: {
            "Content-Type": "application/json; charset=UTF-8",
            "x-auth-token": token,
          },
        );

        return userRes;
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }
}
