import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/productDetails/screen/product_detail_screen.dart';
import 'package:amazon_clone/features/search/services/search_services.dart';
import 'package:amazon_clone/features/search/widgets/search_custom_bar.dart';
import 'package:amazon_clone/features/search/widgets/searched_product.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = "/search-screen";
  final String seacrhQuery;
  const SearchScreen({super.key, required this.seacrhQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchServices searchServices = SearchServices();
  List<ProductModel>? product;

  @override
  void initState() {
    getSearchProduct();
    super.initState();
  }

  void getSearchProduct() async {
    product = await searchServices.fetchSearchProduct(
      productName: widget.seacrhQuery,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return product == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.height(context) * 0.14),
              child: SearchCustomAppBar(user: user),
            ),
            body: ListView.builder(
              itemCount: product!.length,
              itemBuilder: (context, index) {
                final productData = product![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ProductDetailScreen.routeName,
                      arguments: productData,
                    );
                  },
                  child: SearchedProduct(productModel: productData),
                );
              },
            ),
          );
  }
}
