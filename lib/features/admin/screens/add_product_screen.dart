import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/constant/erro_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = "/add-product";
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final AdminServices adminServices = AdminServices();
  final prodNameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    prodNameCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    qtyCtrl.dispose();
    super.dispose();
  }

  final List<String> productCategories = [
    "Mobiles",
    "Essentials",
    "Appliances",
    "Books",
    "Fashion",
  ];

  String? category;

  List<File> images = [];

  void selectImage() async {
    final res = await pickImage();
    setState(() {
      images = res;
    });
  }

  void sellProducts() async {
    // Form validation
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Image validation
    if (images.isEmpty) {
      showSnackBar(context, "Please upload File/Image!");
      return;
    }

    // Category validation
    if (category == null || category!.isEmpty) {
      showSnackBar(context, "Please select a Category!");
      return;
    }

    // If everything is valid → call API
    final res = await adminServices.sellProduct(
      images: images,
      productName: prodNameCtrl.text.trim(),
      description: descCtrl.text.trim(),
      price: double.parse(priceCtrl.text.trim()),
      qty: double.parse(qtyCtrl.text.trim()),
      category: category!,
    );

    if (!mounted) return;

    // API error handling
    final msg = errorHandling(res!);
    if (msg != null) {
      showSnackBar(context, msg);
      return;
    }

    //Response data
    final data = jsonDecode(res.body);
    if (kDebugMode) {
      print("Add Product Response ==> $data");
    }

    // On success
    showSnackBar(context, "Product added successfully!");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height(context) * 0.1),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Text(
            "Add Product",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width(context) * 0.03,
              vertical: Dimensions.height(context) * 0.02,
            ),
            child: Column(
              children: [
                images.isNotEmpty
                    ? GestureDetector(
                        onTap: selectImage,
                        child: CarouselSlider(
                          items: images.map((e) {
                            return Builder(
                              builder: (context) => SizedBox(
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.file(e, fit: BoxFit.contain),
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            viewportFraction: 1,
                            height: Dimensions.height(context) * 0.26,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImage,
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: Radius.circular(5),
                            dashPattern: [10, 4],
                            strokeCap: StrokeCap.round,
                          ),
                          child: Container(
                            width: double.infinity,
                            height: Dimensions.height(context) * 0.22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_outlined,
                                  size: 22,
                                  color: Colors.grey.shade700,
                                ),
                                SizedBox(
                                  height: Dimensions.height(context) * 0.01,
                                ),
                                Text(
                                  "Upload Product Image",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: Dimensions.height(context) * 0.02),
                CustomTextField(
                  hintText: "Product Name",
                  controller: prodNameCtrl,
                ),
                SizedBox(height: Dimensions.height(context) * 0.02),
                CustomTextField(
                  hintText: "Description",
                  controller: descCtrl,
                  maxLine: 4,
                ),
                SizedBox(height: Dimensions.height(context) * 0.02),
                CustomTextField(hintText: "Price", controller: priceCtrl),
                SizedBox(height: Dimensions.height(context) * 0.02),
                CustomTextField(hintText: "Quantity", controller: qtyCtrl),
                SizedBox(height: Dimensions.height(context) * 0.02),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(5),
                    value: category,
                    hint: Padding(
                      padding: EdgeInsets.only(
                        left: Dimensions.width(context) * 0.05,
                      ),
                      child: Text("Select a Category"),
                    ),
                    icon: Icon(Icons.arrow_drop_down),
                    items: productCategories.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: Dimensions.width(context) * 0.05,
                          ),
                          child: Text(e),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                    },
                    underline: SizedBox(),
                  ),
                ),
                SizedBox(height: Dimensions.height(context) * 0.02),
                CustomButton(
                  text: "Submit",
                  onpress: () {
                    sellProducts();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
