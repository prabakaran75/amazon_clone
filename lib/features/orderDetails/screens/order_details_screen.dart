import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/orderDetails/widgets/custom_order_app_bar.dart';
import 'package:amazon_clone/models/order_models.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = "/order-details";
  final OrderModels order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final adminServices = AdminServices();
  int currentStep = 0;
  @override
  void initState() {
    currentStep = widget.order.status;
    super.initState();
  }

  //For Admin
  void changeOrderStatus(int status) {
    adminServices.changeOrderStatus(status: status + 1, orders: widget.order);
    setState(() {
      currentStep += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height(context) * 0.08),
        child: CustomOrderAppBar(),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: Dimensions.height(context) * 0.01,
          horizontal: Dimensions.width(context) * 0.02,
        ),
        children: [
          Text(
            "View order details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Date: ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt))}",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                Text(
                  "Order ID: ${widget.order.id}",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                Text(
                  "Order Total: \u{20B9}${widget.order.totalPrice}",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Text(
            "Purchase details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: [
                for (int i = 0; i < widget.order.products.length; i++)
                  Row(
                    children: [
                      SizedBox(
                        width: Dimensions.height(context) * 0.18,
                        child: Image.network(
                          widget.order.products[i].images[0],
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(width: Dimensions.width(context) * 0.02),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.order.products[i].productName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Qty: ${widget.order.quantities[i]}",
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                            SizedBox(height: Dimensions.height(context) * 0.02),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Text(
            "Tracking",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
            ),
            child: Stepper(
              currentStep: currentStep,
              controlsBuilder: (context, details) {
                if (user.type == "admin") {
                  return CustomButton(
                    text: "Done",
                    onpress: () => changeOrderStatus(details.currentStep),
                    ht: Dimensions.height(context) * 0.065,
                  );
                }
                return SizedBox();
              },
              steps: [
                Step(
                  title: Text(
                    "Pending",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  content: Padding(
                    padding: EdgeInsets.only(
                      bottom: Dimensions.height(context) * 0.01,
                    ),
                    child: Text(
                      "Your order yet to be delivered",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  isActive: currentStep >= 0,
                  state: currentStep > 0
                      ? StepState.complete
                      : StepState.indexed,
                ),
                Step(
                  title: Text(
                    "Completed",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  content: Padding(
                    padding: EdgeInsets.only(
                      bottom: Dimensions.height(context) * 0.01,
                    ),
                    child: Text(
                      "Your order ready to deliver, waiting for customer confirmation",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  isActive: currentStep >= 1,
                  state: currentStep > 1
                      ? StepState.complete
                      : StepState.indexed,
                ),
                Step(
                  title: Text(
                    "Received",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  content: Padding(
                    padding: EdgeInsets.only(
                      bottom: Dimensions.height(context) * 0.01,
                    ),
                    child: Text(
                      "Your order has been delivered, got customer confirmed",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  isActive: currentStep >= 2,
                  state: currentStep > 2
                      ? StepState.complete
                      : StepState.indexed,
                ),
                Step(
                  title: Text(
                    "Delivered",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  content: Padding(
                    padding: EdgeInsets.only(
                      bottom: Dimensions.height(context) * 0.01,
                    ),
                    child: Text(
                      "Your order has been delivered, got customer confirmed!",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  isActive: currentStep >= 3,
                  state: currentStep >= 3
                      ? StepState.complete
                      : StepState.indexed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
