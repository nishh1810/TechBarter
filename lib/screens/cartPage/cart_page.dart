import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/screens/cartPage/components/cart_table.dart';

import 'components/cart_summary.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    Provider.of<CartProvider>(context, listen: false).getCartItems();
    return CustomScaffold(
      curIndex: 4,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cart", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CartTable(),
            const SizedBox(height: 20),
            CartSummary(),
          ]
        ),
      ),
    );
  }
}
