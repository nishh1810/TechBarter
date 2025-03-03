import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/quantity_stepper.dart';
import 'package:tech_barter/models/cart_product.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';

class CartTable extends StatefulWidget {
  const CartTable({super.key});

  @override
  State<CartTable> createState() => _CartTableState();
}

class _CartTableState extends State<CartTable> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartProducts = cartProvider.cartProducts.toList();
    final theme = Theme.of(context);


    if (cartProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 48, color: theme.hintColor),
            const SizedBox(height: 16),
            Text(
              'Your cart is empty',
              style: theme.textTheme.titleMedium?.copyWith(color: theme.hintColor),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),   // Product
          1: FlexColumnWidth(1.5), // Price
          2: FlexColumnWidth(2),   // Quantity
          3: FlexColumnWidth(1.5), // Subtotal
          4: FixedColumnWidth(48), // Delete button
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade200),
          verticalInside: BorderSide(color: Colors.grey.shade200),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            children: [
              _buildHeaderCell('Product', theme),
              _buildHeaderCell('Price', theme),
              _buildHeaderCell('Quantity', theme),
              _buildHeaderCell('Subtotal', theme),
              _buildHeaderCell('', theme), // Empty header for delete column
            ],
          ),
          ...cartProducts.map((cartProduct) => _buildTableRow(cartProduct, cartProvider, context)),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  TableRow _buildTableRow(CartProduct cartProduct, CartProvider cartProvider, BuildContext context) {
    final theme = Theme.of(context);
    int currentQuantity = cartProduct.cartQuantity ?? 1;

    return TableRow(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            cartProduct.name ?? '',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '\$${cartProduct.price?.toStringAsFixed(2) ?? '0.00'}',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: StatefulBuilder(
            builder: (context, setState) {
              return QuantityStepper(
                quantity: currentQuantity,
                maxQuantity: cartProduct.itemQuantity ?? 10,
                onQuantityChanged: (int value) {
                  setState(() {
                    currentQuantity = value; // Update local state
                  });

                  // Update cart quantity
                  final userProvider = Provider.of<UserProvider>(context, listen: false);
                  if (cartProduct.productId != null && userProvider.user?.id != null) {
                    cartProvider.addToCart(
                      cartProduct.productId!,
                      userProvider.user!.id!,
                      value,
                    );
                  }
                },
              );
            },
          )
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            '\$${cartProduct.total?.toStringAsFixed(2) ?? '0.00'}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: IconButton(
            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              if (cartProduct.productId != null && userProvider.user?.id != null) {
                cartProvider.removeFromCart(
                  cartProduct.productId!
                );
              }
            },
          ),
        ),
      ],
    );
  }
}