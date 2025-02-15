import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/providers/cart_provider.dart';

class CartSummary extends StatefulWidget {

  const CartSummary({super.key});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCartTotalRow("Subtotal", "\$${cartProvider.totalAmount.toStringAsFixed(2)}"),
              _buildCartTotalRow("Shipping", "Free"),
              const Divider(),
              _buildCartTotalRow("Total", "\$${cartProvider.totalAmount.toStringAsFixed(2)}", isBold: true),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text("Proceed to Checkout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartTotalRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
