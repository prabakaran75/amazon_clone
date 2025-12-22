import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/orderDetails/screens/order_details_screen.dart';
import 'package:amazon_clone/features/profiels/widgets/signle_product_structure.dart';
import 'package:amazon_clone/models/order_models.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final adminServices = AdminServices();
  List<OrderModels>? orders;

  void fetchOrders() async {
    orders = await adminServices.fetchAllOrders();
    setState(() {});
  }

  @override
  void initState() {
    fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? Center(child: CircularProgressIndicator())
        : GridView.builder(
            itemCount: orders!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final order = orders![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailsScreen.routeName,
                    arguments: order,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: SignleProductStructure(
                    image: order.products[0].images[0],
                  ),
                ),
              );
            },
          );
  }
}
