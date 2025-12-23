import 'package:amazon_clone/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: "",
    name: "",
    email: "",
    password: "",
    address: "",
    type: "",
    token: "",
    cart: [],
  );

  UserModel get user => _user;

  void setUser(String user) {
    _user = UserModel.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearCart() {
    _user = _user.copyWith(cart: []);
    notifyListeners();
  }

  // ✅ IMPORTANT FOR LOGOUT
  void clearUser() {
    _user = UserModel(
      id: "",
      name: "",
      email: "",
      password: "",
      address: "",
      type: "",
      token: "",
      cart: [],
    );
    notifyListeners(); // 🔥 this rebuilds UI
  }
}
