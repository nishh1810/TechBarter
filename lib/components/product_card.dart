import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_notification.dart';
import 'package:tech_barter/models/Product.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/providers/product_provider.dart';
import 'package:tech_barter/providers/review_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/utils/route_strings.dart';
import 'package:tech_barter/utils/shared_preference_helper.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({
    super.key,
    required this.product,
  });

  _onCardClick(context) {
    Provider.of<ProductProvider>(context, listen: false).setSelectedProduct(product);
    Provider.of<ReviewProvider>(context, listen: false).getReviews(product.id!);
    SPHelper.setData(SPHelper.KEY_SELECTED_PRODUCT, json.encode(product));
    GoRouter.of(context).go(RouteName.productPage);
  }

  _addToCartClick(context) {
    try {
      if(Provider.of<UserProvider>(context, listen: false).user == null) {
        NotificationService.showFixedWidthSnackbar(context, "Please login to add to cart");
        return;
      }

      String userId = Provider.of<UserProvider>(context, listen: false).user!.id!;

      Provider.of<CartProvider>(context, listen: false).addToCart(product.id!, userId, 1);

      NotificationService.showFixedWidthSnackbar(context, "Added to cart");
    } catch(e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = product.price?.toStringAsFixed(2) ?? '0.00';

    return InkWell(
      onTap: () => _onCardClick(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 200,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 2),
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 200,
                    color: Colors.grey.shade100,
                    child: product.images != null && product.images!.isNotEmpty
                        ? FutureBuilder<String>(
                      future: Provider.of<ProductProvider>(context, listen: false)
                          .loadProductImage(product.images!.first.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error, color: Colors.grey);
                        } else {
                          return Image.network(
                            snapshot.data.toString(),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, color: Colors.grey),
                          );
                        }
                      },
                    )
                        : Image.network(
                      "https://picsum.photos/id/${Random().nextInt(100)}/300/300",
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart,
                          size: 18,
                          color: theme.colorScheme.onPrimary),
                      onPressed: () => _addToCartClick(context),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ),
                ),
                if (product.avgRating != null)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 14),
                          SizedBox(width: 4),
                          Text(
                            product.avgRating!.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name ?? "Product Name",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),

                  // Price
                  Text(
                    '\$$price',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),

                  // Reviews count
                  if (product.totalReview != null && product.totalReview! > 0)
                    Text(
                      '${product.totalReview} reviews',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
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