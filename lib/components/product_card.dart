import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/models/Product.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/providers/product_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/utils/route_strings.dart';
import 'package:tech_barter/utils/shared_preference_helper.dart';

class ProductCard extends StatelessWidget {
  Product product;

  ProductCard({
    super.key,
    required this.product,
  });

  _onCardClick(context) {
    Provider.of<ProductProvider>(context, listen: false).setSelectedProduct(product);
    SPHelper.setData(SPHelper.KEY_SELECTED_PRODUCT, json.encode(product));
    GoRouter.of(context).go(RouteName.productPage);
  }

  _onFavoriteClick(context) {

  }

  _addToCartClick(context) {
    String userId = Provider.of<UserProvider>(context, listen: false).user!.id!;
    Provider.of<CartProvider>(context, listen: false).addToCart(product.id!, userId, 1);
  }

  String oldPrice = "0.0";
  String reviews = "0";

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onCardClick(context),
      child: Container(
        width: 240,
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white54,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Icons
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "https://picsum.photos/id/${Random().nextInt(500)}/3000/2000",
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.favorite_border, size: 20),
                        onPressed: () => _onFavoriteClick(context),
                      ),
                      SizedBox(height: 8),
                      IconButton(
                        icon: Icon(Icons.shopping_cart, size: 20),
                        onPressed: () => _addToCartClick(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Product Name
            Text(
              product.name ?? "---",
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),

            // Pricing Section
            Row(
              children: [
                Text(
                  product.price.toString(),
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 5),
                if (oldPrice.isNotEmpty)
                  Text(
                    oldPrice,
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 5),

            // Rating Section
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 16),
                Icon(Icons.star, color: Colors.orange, size: 16),
                Icon(Icons.star, color: Colors.orange, size: 16),
                Icon(Icons.star, color: Colors.orange, size: 16),
                Icon(Icons.star_half, color: Colors.orange, size: 16),
                SizedBox(width: 5),
                Text('($reviews)', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}