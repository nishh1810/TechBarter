import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/components/custom_text_field.dart';
import 'package:tech_barter/platforms/loading_button.dart';
import 'package:tech_barter/platforms/payment_element.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/services/payment_service.dart';
import 'package:tech_barter/utils/validators.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  UserProvider? userProvider;
  CartProvider? cartProvider;
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  String? clientSecret;

  @override
  void initState() {
    _getPaymentIntent();
    super.initState();
  }

  void _getPaymentIntent() async {
    try {
      cartProvider = Provider.of<CartProvider>(context, listen: false);
      if (cartProvider!.finalAmount != 0) {
        Map<String, dynamic>? data = await PaymentService.createPaymentIntent(
            cartProvider!.finalAmount, "CAD");
        setState(() {
          clientSecret = data!['clientSecret'];
        });
      }
    } catch (e) {
      print("Payment intent error :: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    _streetController.text = userProvider?.user?.address?.street ?? "";
    _cityController.text = userProvider?.user?.address?.city ?? "";
    _stateController.text = userProvider?.user?.address?.state ?? "";
    _countryController.text = userProvider?.user?.address?.country ?? "";
    _zipController.text = userProvider?.user?.address?.zipCode ?? "";

    return CustomScaffold(
      curIndex: -1,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Checkout",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Billing Address",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        _buildAddressForm(),
                        const SizedBox(height: 24),
                        Text("Order Summary",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        _buildTotalRow("Subtotal",
                            "\$${cartProvider?.totalAmount.toStringAsFixed(2)}"),
                        _buildTotalRow("HST - 13%",
                            "\$${cartProvider?.taxAmount.toStringAsFixed(2)}"),
                        const Divider(height: 24),
                        _buildTotalRow("Total",
                            "\$${cartProvider?.finalAmount.toStringAsFixed(2)}",
                            isBold: true),
                      ],
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              if (clientSecret != null)
                                PlatformPaymentElement(clientSecret!),
                              const SizedBox(height: 24),
                              if (clientSecret != null)
                                SizedBox(
                                  width: double.infinity,
                                  child: LoadingButton(
                                    onPressed: pay,
                                    text: 'Pay Now',
                                    buttonStyle: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              if (clientSecret == null)
                                const Center(
                                    child: CircularProgressIndicator()),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: "Street",
          hintText: "Enter your street address",
          controller: _streetController,
          validator: (value) => Validators.validateText(value, "Street"),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: "City",
                hintText: "Enter your city",
                controller: _cityController,
                validator: (value) => Validators.validateText(value, "City"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: "State",
                hintText: "Enter your state",
                controller: _stateController,
                validator: (value) => Validators.validateText(value, "State"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: "Country",
                hintText: "Enter your country",
                controller: _countryController,
                validator: (value) => Validators.validateText(value, "Country"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: "Zip Code",
                hintText: "Enter your postal code",
                controller: _zipController,
                validator: (value) => Validators.validateText(value, "Zip Code"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
                  color: Colors.grey[700])),
          Text(value,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[700])),
        ],
      ),
    );
  }
}