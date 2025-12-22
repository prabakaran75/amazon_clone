import 'package:amazon_clone/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/features/address/widgets/address_custom_app_bar.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = "/address-screen";
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final flatNoCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final addressService = AddressServices();

  final _formKey = GlobalKey<FormState>();

  bool hasUserStartedTyping = false;
  bool isFormComplete = false;

  PaymentConfiguration? _paymentConfiguration;
  final List<PaymentItem> _paymentItems = [];

  String addressToBeUsed = "";

  @override
  void initState() {
    super.initState();

    _loadGpayConfig();

    flatNoCtrl.addListener(_onFormChanged);
    areaCtrl.addListener(_onFormChanged);
    pincodeCtrl.addListener(_onFormChanged);
    cityCtrl.addListener(_onFormChanged);

    _paymentItems.add(
      PaymentItem(
        label: 'Total Amount',
        amount: widget.totalAmount,
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  void _onFormChanged() {
    final anyTouched =
        flatNoCtrl.text.isNotEmpty ||
        areaCtrl.text.isNotEmpty ||
        pincodeCtrl.text.isNotEmpty ||
        cityCtrl.text.isNotEmpty;

    final allFilled =
        flatNoCtrl.text.isNotEmpty &&
        areaCtrl.text.isNotEmpty &&
        pincodeCtrl.text.isNotEmpty &&
        cityCtrl.text.isNotEmpty;

    setState(() {
      hasUserStartedTyping = anyTouched;
      isFormComplete = allFilled;
    });
  }

  Future<void> _loadGpayConfig() async {
    final configString = await rootBundle.loadString('assets/pay/gpay.json');
    setState(() {
      _paymentConfiguration = PaymentConfiguration.fromJsonString(configString);
    });
  }

  bool _canPayNow(String existingAddress) {
    // User started typing → form is mandatory
    if (hasUserStartedTyping) {
      return isFormComplete;
    }

    // User did not touch form → existing address allowed
    return existingAddress.isNotEmpty;
  }

  void _handlePayPressed(String existingAddress) {
    // Show validation errors if form was touched
    if (hasUserStartedTyping) {
      final valid = _formKey.currentState!.validate();
      if (!valid) return;

      addressToBeUsed =
          "${flatNoCtrl.text}, ${areaCtrl.text} - ${pincodeCtrl.text} ${cityCtrl.text}";
    } else {
      addressToBeUsed = existingAddress;
    }

    debugPrint("✅ Address confirmed: $addressToBeUsed");
    // Google Pay proceeds automatically
  }

  Future<void> addAddressToUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("x-auth-token")!;

      final updatedUser = await addressService.saveUserAddress(
        address: addressToBeUsed,
        token: token,
      );

      if (!mounted) return;
      Provider.of<UserProvider>(
        context,
        listen: false,
      ).setUserFromModel(updatedUser);

      debugPrint("Address updated successfully");
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, e.toString());
    }
  }

  void placeOrder() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final order = await addressService.placeOrder(
        cart: userProvider.user.cart,
        address: addressToBeUsed,
        totalPrice: double.parse(widget.totalAmount),
      );

      if (!mounted) return;

      userProvider.clearCart();
      showSnackBar(context, "Order placed successfully!");

      debugPrint("The order ${order.toJson()}");
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, e.toString());
    }
  }

  Future<void> onPaymentSuccess() async {
    final userProvider = context.read<UserProvider>();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("x-auth-token")!;

    // 1️⃣ Save address only once
    if (userProvider.user.address.isEmpty) {
      final updatedUser = await addressService.saveUserAddress(
        address: addressToBeUsed,
        token: token,
      );

      if (!mounted) return;
      userProvider.setUserFromModel(updatedUser);
    }

    // 2️⃣ Place order
    final order = await addressService.placeOrder(
      cart: userProvider.user.cart,
      address: addressToBeUsed,
      totalPrice: double.parse(widget.totalAmount),
    );

    if (!mounted) return;

    // 3️⃣ Clear cart & notify UI
    userProvider.clearCart();
    showSnackBar(context, "Order placed successfully!");

    debugPrint("Order placed: ${order.id}");
  }

  @override
  void dispose() {
    flatNoCtrl.dispose();
    areaCtrl.dispose();
    pincodeCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final existingAddress = context.watch<UserProvider>().user.address;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Dimensions.height(context) * 0.08),
        child: AddressCustomAppBar(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width(context) * 0.03,
          vertical: Dimensions.height(context) * 0.02,
        ),
        child: Column(
          children: [
            existingAddress.isNotEmpty
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.height(context) * 0.017,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          existingAddress,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: Dimensions.height(context) * 0.02),
                      const Text("OR"),
                      SizedBox(height: Dimensions.height(context) * 0.02),
                    ],
                  )
                : SizedBox(),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    hintText: "Flat, House no, Building",
                    controller: flatNoCtrl,
                  ),
                  SizedBox(height: Dimensions.height(context) * 0.02),
                  CustomTextField(
                    hintText: "Area, Street",
                    controller: areaCtrl,
                  ),
                  SizedBox(height: Dimensions.height(context) * 0.02),
                  CustomTextField(hintText: "Pincode", controller: pincodeCtrl),
                  SizedBox(height: Dimensions.height(context) * 0.02),
                  CustomTextField(hintText: "Town/City", controller: cityCtrl),
                  SizedBox(height: Dimensions.height(context) * 0.02),

                  if (_paymentConfiguration == null)
                    const CircularProgressIndicator()
                  else
                    GestureDetector(
                      onTap: !_canPayNow(existingAddress)
                          ? () {
                              _formKey.currentState?.validate();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please complete address before payment",
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: AbsorbPointer(
                        absorbing: !_canPayNow(existingAddress),
                        child: GooglePayButton(
                          width: double.infinity,
                          height: Dimensions.height(context) * 0.06,
                          paymentConfiguration: _paymentConfiguration!,
                          paymentItems: _paymentItems,
                          type: GooglePayButtonType.buy,
                          onPressed: () => _handlePayPressed(existingAddress),
                          onPaymentResult: (paymentResult) {
                            debugPrint("Payment success: $paymentResult");
                            onPaymentSuccess();
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
