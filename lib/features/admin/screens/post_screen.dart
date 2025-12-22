import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/admin/widgets/admin_custom_app_bar.dart';
import 'package:amazon_clone/features/profiels/widgets/signle_product_structure.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final AdminServices adminServices = AdminServices();
  List<ProductModel>? prodcuts;
  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  void fetchProducts() async {
    prodcuts = await adminServices.fetchAllProducts();
    if (kDebugMode) {
      print("Fetched Product => $prodcuts");
    }
    setState(() {});
  }

  void onDelete(ProductModel product) async {
    String? msg = await adminServices.deleteProduct(product.id!);

    if (!mounted) return;

    showSnackBar(context, msg!);

    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return prodcuts == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.height(context) * 0.1),
              child: AdminCustomAppBar(),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width(context) * 0.02,
                vertical: Dimensions.height(context) * 0.02,
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  crossAxisCount: 2,
                ),
                itemCount: prodcuts!.length,
                itemBuilder: (context, index) {
                  final data = prodcuts![index];
                  return Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: SignleProductStructure(image: data.images[0]),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data.productName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              onDelete(data);
                            },
                            icon: Icon(Icons.delete, size: 20),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Colors.cyan[700],
              onPressed: () async {
                await Navigator.pushNamed(context, AddProductScreen.routeName);
                fetchProducts();
              },
              tooltip: "Add a Product",
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
