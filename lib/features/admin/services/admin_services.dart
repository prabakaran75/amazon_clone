import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/models/order_models.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdminServices {
  //Add Product
  Future<http.Response?> sellProduct({
    required List<File> images,
    required String productName,
    required String description,
    required double price,
    required double qty,
    required String category,
  }) async {
    try {
      final cloudinary = CloudinaryPublic("dalxbugku", "UploadUnsigned");
      List<String> imagesUrl = [];
      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: productName),
        );
        imagesUrl.add(res.secureUrl);
      }
      ProductModel productModel = ProductModel(
        images: imagesUrl,
        productName: productName,
        description: description,
        price: price,
        qty: qty,
        category: category,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");
      if (token == null) {
        prefs.setString("x-auth-token", "");
        return null;
      }

      final res = await http.post(
        Uri.parse("$uri/admin/add-product"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token,
        },
        body: productModel.toJson(),
      );

      return res;
    } catch (e) {
      throw e.toString();
    }
  }

  //Fetch All Products
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("x-auth-token");

      final res = await http.get(
        Uri.parse("$uri/admin/get-products"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );

      if (res.statusCode == 200) {
        final List productList = jsonDecode(res.body);
        return productList.map((e) => ProductModel.fromMap(e)).toList();
      } else {
        throw Exception("Failed to Load Product");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Delete Product
  Future<String?> deleteProduct(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      final res = await http.post(
        Uri.parse("$uri/admin/delete-product"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
        body: jsonEncode({"id": id}),
      );

      if (res.statusCode == 200) {
        return "Product deleted successfully!";
      } else {
        final body = jsonDecode(res.body);
        return body["msg"] ?? "Failed to delete product.";
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //fetchOrder
  Future<List<OrderModels>> fetchAllOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("x-auth-token");

      final res = await http.get(
        Uri.parse("$uri/admin/get-orders"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );

      if (res.statusCode == 200) {
        final List orderList = jsonDecode(res.body);
        return orderList.map((e) => OrderModels.fromMap(e)).toList();
      } else {
        throw Exception("Failed to fetch the orders");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //Change status
  void changeOrderStatus({
    required int status,
    required OrderModels orders,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("x-auth-token");

      await http.post(
        Uri.parse("$uri/admin/change-order-status"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
        body: jsonEncode({"id": orders.id, "status": status}),
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //GetEarnings
  Future<Map<String, dynamic>> getEarnings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("x-auth-token");
      List<Sales> sales = [];
      int totalEarnings = 0;
      final res = await http.get(
        Uri.parse("$uri/admin/analytics"),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "x-auth-token": token!,
        },
      );
      var response = jsonDecode(res.body);
      totalEarnings = response['totalEarning'];
      sales = [
        Sales(label: "Mobiles", earning: response["mobileEarnings"]),
        Sales(label: "Essentials", earning: response["essentialEarnings"]),
        Sales(label: "Appliances", earning: response["appliancesEarnings"]),
        Sales(label: "Books", earning: response["booksEarnings"]),
        Sales(label: "Fashion", earning: response["fashionEarnings"]),
      ];
      return {"sales": sales, "totalEarnings": totalEarnings};
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
