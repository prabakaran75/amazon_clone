import 'package:amazon_clone/common/bottomBar/gv_bottom_nav_bar.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/screens/admin_bottom_bar.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/category_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/features/orderDetails/screens/order_details_screen.dart';
import 'package:amazon_clone/features/productDetails/screen/product_detail_screen.dart';
import 'package:amazon_clone/features/search/screens/search_screen.dart';
import 'package:amazon_clone/models/order_models.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AuthScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => HomeScreen(),
      );

    case GvBottomNavBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => GvBottomNavBar(),
      );

    case AdminBottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AdminBottomBar(),
      );

    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddProductScreen(),
      );

    case CategoryScreen.routeName:
      final category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryScreen(category: category),
      );

    case SearchScreen.routeName:
      final searchValue = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(seacrhQuery: searchValue),
      );

    case ProductDetailScreen.routeName:
      final product = routeSettings.arguments as ProductModel;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(product: product),
      );

    case AddressScreen.routeName:
      final totalAmount = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(totalAmount: totalAmount),
      );

    case OrderDetailsScreen.routeName:
      final orders = routeSettings.arguments as OrderModels;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailsScreen(order: orders),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
            Scaffold(body: Center(child: Text("Screen does not exist!"))),
      );
  }
}
