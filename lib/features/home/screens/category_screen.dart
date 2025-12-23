import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/home/services/home_service.dart';
import 'package:amazon_clone/features/productDetails/screen/product_detail_screen.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = "/category-screen";
  final String category;
  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final HomeService homeService = HomeService();
  List<ProductModel>? productList;
  @override
  void initState() {
    fetchCategory();
    super.initState();
  }

  void fetchCategory() async {
    productList = await homeService.fetchCategoryProducts(
      category: widget.category,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(Dimensions.height(context) * 0.1),
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
            title: Text(
              widget.category,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            centerTitle: true,
          ),
        ),
        body: productList == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width(context) * 0.02,
                    vertical: Dimensions.height(context) * 0.01,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Keep shopping ${widget.category}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height(context) * 0.01),
                      SizedBox(
                        height: Dimensions.height(context) * 0.28,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productList!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 1.2,
                                mainAxisSpacing:
                                    Dimensions.width(context) * 0.02,
                              ),
                          itemBuilder: (context, index) {
                            final product = productList![index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ProductDetailScreen.routeName,
                                  arguments: product,
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: Dimensions.height(context) * 0.18,
                                    decoration: BoxDecoration(
                                      // border: Border.all(
                                      //   color: Colors.black,
                                      //   width: 1.2,
                                      // ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        product.images[1],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      product.productName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
