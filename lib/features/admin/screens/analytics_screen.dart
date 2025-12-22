import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/admin/widgets/admin_custom_app_bar.dart';
import 'package:amazon_clone/features/admin/widgets/earning_bar_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    getEarnings();
    super.initState();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings();
    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.height(context) * 0.1),
              child: AdminCustomAppBar(),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: Dimensions.width(context) * 0.02,
                  vertical: Dimensions.height(context) * 0.02,
                ),
                child: Column(
                  children: [
                    Text(
                      "\u{20B9}$totalSales",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimensions.height(context) * 0.02),
                    EarningBarChart(earnings: earnings!),
                    SizedBox(height: Dimensions.height(context) * 0.02),
                  ],
                ),
              ),
            ),
          );
  }
}
