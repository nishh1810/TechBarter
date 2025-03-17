import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/utils/route_strings.dart';

class CartSummary extends StatefulWidget {
  const CartSummary({super.key});

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCartTotalRow(
              context,
              "Subtotal",
              "\$${cartProvider.totalAmount.toStringAsFixed(2)}",
            ),
            _buildCartTotalRow(context, "Shipping", "Free"),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _buildCartTotalRow(
              context,
              "Total",
              "\$${cartProvider.totalAmount.toStringAsFixed(2)}",
              isBold: true,
              isTotal: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go(RouteName.checkoutPage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Proceed to Checkout",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  GoRouter.of(context).go(RouteName.productCatalogPage);
                },
                child: Text(
                  "Continue Shopping",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartTotalRow(
      BuildContext context,
      String title,
      String value, {
        bool isBold = false,
        bool isTotal = false,
      }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            )
                : theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            )
                : theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}