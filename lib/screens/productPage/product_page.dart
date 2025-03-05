import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_notification.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/components/quantity_stepper.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/providers/product_provider.dart';
import 'package:tech_barter/providers/user_provider.dart';
import 'package:tech_barter/screens/productPage/components/related_products.dart';
import 'package:tech_barter/utils/route_strings.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _currentQuantity = 1;
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (Provider.of<ProductProvider>(context).getSelectedProduct == null) {
      return CustomScaffold(body: Center(child: CircularProgressIndicator()));
    }

    return CustomScaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            // Main Product Section
            _buildDesktopLayout(theme),

            SizedBox(height: 40),

            // Related Products
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.getSelectedProduct!.id != null) {
                  return RelatedProducts(
                    productId: productProvider.getSelectedProduct!.id.toString(),
                  );
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    final product = Provider.of<ProductProvider>(context).getSelectedProduct!;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail Images
            if (product.images != null && product.images!.isNotEmpty)
              SizedBox(
                width: 80,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: product.images!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () => setState(() => _selectedImageIndex = index),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedImageIndex == index
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _buildImageFuture(product.images![index].id),
                      )
                    );
                  },
                ),
              ),

            SizedBox(width: 16),

            // Main Product Image
            Expanded(
              flex: 4,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: product.images != null && product.images!.isNotEmpty
                      ? _buildImageFuture(
                    product.images![_selectedImageIndex].id,
                    fit: BoxFit.contain,
                    backgroundColor: theme.cardColor,
                  )
                  : Container(
                    color: theme.cardColor,
                    child: Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),

            SizedBox(width: 32),

            // Product Details
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name ?? "Product Name",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 12),

                    // Recyclable badge
                    if (product.isRecyclable == true)
                      Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Chip(
                          label: Text("Recyclable"),
                          backgroundColor: Colors.green.withOpacity(0.2),
                          labelStyle: TextStyle(color: Colors.green),
                          shape: StadiumBorder(),
                        ),
                      ),

                    // Rating and stock status
                    Row(
                      children: [
                        _buildRatingStars(product.avgRating ?? 0),
                        SizedBox(width: 8),
                        Text(
                          "(${product.totalReview ?? 0} Reviews)",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 16,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(width: 8),
                        Text(
                          product.quantity! > 0 ? "In Stock" : "Out of Stock",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: product.quantity! > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Price
                    Text(
                      "\$${product.price?.toStringAsFixed(2) ?? '0.00'}",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 24),

                    // Description
                    Text(
                      "Description",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      product.description ?? "No description available",
                      style: theme.textTheme.bodyMedium,
                    ),

                    SizedBox(height: 32),

                    // Quantity and Buy Button
                    Row(
                      children: [
                        StatefulBuilder(
                          builder: (context, setState) {
                            return QuantityStepper(
                              quantity: _currentQuantity,
                              maxQuantity: product.quantity!,
                              onQuantityChanged: (value) =>
                                  setState(() => _currentQuantity = value),
                            );
                          }
                        ),

                        SizedBox(width: 20),

                        Expanded(
                          child: Consumer3<UserProvider, ProductProvider, CartProvider>(
                            builder: (context, userProvider, productProvider, cartProvider, child) {
                              return ElevatedButton(
                                onPressed: () {
                                  if (productProvider.getSelectedProduct!.quantity! <= 0) {
                                    NotificationService.showFixedWidthSnackbar(
                                      context,
                                      "Product is out of stock.",
                                    );
                                    return;
                                  }
                                  if (userProvider.user == null) {
                                    NotificationService.showFixedWidthSnackbar(
                                      context,
                                      "Please login to purchase.",
                                    );
                                    return;
                                  }
                                  cartProvider.addToCart(
                                    productProvider.getSelectedProduct!.id!,
                                    userProvider.user!.id!,
                                    _currentQuantity,
                                  );
                                  GoRouter.of(context).go(RouteName.cartPage);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Buy Now",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (rating >= index + 1) {
          return Icon(Icons.star, color: Colors.amber, size: 20);
        } else if (rating > index) {
          return Icon(Icons.star_half, color: Colors.amber, size: 20);
        } else {
          return Icon(Icons.star_border, color: Colors.grey, size: 20);
        }
      }),
    );
  }

  Widget _buildImageFuture(String? imageId, {
    BoxFit fit = BoxFit.cover,
    Color? backgroundColor,
  }) {
    return FutureBuilder<String>(
      future: Provider.of<ProductProvider>(context, listen: false)
          .loadProductImage(imageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: backgroundColor ?? Colors.grey.shade100,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            color: backgroundColor ?? Colors.grey.shade100,
            child: Center(child: Icon(Icons.broken_image, color: Colors.grey)),
          );
        } else {
          return Image.network(
            snapshot.data!,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => Container(
              color: backgroundColor ?? Colors.grey.shade100,
              child: Center(child: Icon(Icons.broken_image, color: Colors.grey)),
            ),
          );
        }
      },
    );
  }
}