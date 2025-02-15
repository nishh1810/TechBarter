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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 64, vertical: 32),
        child: Column(
          children: [
            CartTable(),
            const SizedBox(height: 20),
            CartSummary(),
          ]
        ),
      ),
    );
  }
}
