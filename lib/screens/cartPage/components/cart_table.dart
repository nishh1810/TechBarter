import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/quantity_stepper.dart';
import 'package:tech_barter/models/cart_product.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';

class CartTable extends StatefulWidget {
  const CartTable({
    super.key,
  });

  @override
  State<CartTable> createState() => _CartTableState();
}

class _CartTableState extends State<CartTable> {

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final cartProducts = cartProvider.cartProducts.toList();

    return Table(
      border: TableBorder.all(color: Colors.black26),
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(
            color: Colors.black12

          ),
          children: [
            Padding(padding: EdgeInsets.all(8.0), child: Text("Product", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8.0), child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8.0), child: Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8.0), child: Text("Subtotal", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),

        for (var cartProduct in cartProducts) _tableRow(cartProduct, cartProvider),
      ],
    );
  }

  _tableRow(CartProduct cartProduct, CartProvider cartProvider) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text(cartProduct.name!)),
        Padding(padding: const EdgeInsets.all(8.0), child: Text("\$${cartProduct.price!}")),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QuantityStepper(
            quantity: cartProduct.cartQuantity!,
            maxQuantity: cartProduct.itemQuantity!,
            onQuantityChanged: (int value) {
              print("Current Quantity: $value");
              cartProvider.addToCart(
                  cartProduct.productId!,
                  Provider.of<UserProvider>(context, listen: false).user!.id!,
                  value);
            }
          ),
        ),
        Padding(padding: const EdgeInsets.all(8.0), child: Text("\$${cartProduct.total?.toStringAsFixed(2)}")),
      ],
    );
  }
}