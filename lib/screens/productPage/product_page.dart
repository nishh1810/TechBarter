import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_notification.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/components/quantity_stepper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tech_barter/models/Product.dart';
import 'package:tech_barter/models/review.dart';
import 'package:tech_barter/providers/cart_provider.dart';
import 'package:tech_barter/providers/product_provider.dart';
import 'package:tech_barter/providers/review_provider.dart';
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

  final GlobalKey<_KeyControlledStatefulBuilderState> _ratingKey = GlobalKey();
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0.0;
  bool _isReviewing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (Provider.of<ProductProvider>(context).getSelectedProduct == null) {
      return CustomScaffold(curIndex: 1, body: Center(child: CircularProgressIndicator()));
    }

    return CustomScaffold(
      curIndex: 1,
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

                        SizedBox(height: 32),
                      ],
                    ),

                    SizedBox(height: 32),

                    Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                        if (userProvider.user != null) {
                          return _buildAddReviewSection(theme, product);
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        _buildReviewsSection(theme, product),
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


  Widget _buildReviewsSection(ThemeData theme, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reviews",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),

        // Show loading if reviews are being fetched
        Consumer<ReviewProvider>(
          builder: (context, reviewProvider, child) {

            // Show message if no reviews
            if (reviewProvider.reviews.isEmpty) {
              return Text(
                "No reviews yet. Be the first to review!",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              );
            }

            // Display reviews
            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // Number of columns
                crossAxisSpacing: 16, // Spacing between columns
                mainAxisSpacing: 16, // Spacing between rows
                childAspectRatio: 3, // Width to height ratio of each item
              ),
              itemCount: reviewProvider.reviews.length,
              itemBuilder: (context, index) {
                return _buildReviewCard(theme, reviewProvider.reviews[index]);
              },
            );
          },
        ),
      ],
    );
  }


  Widget _buildReviewCard(ThemeData theme, Review review) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and rating
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: theme.colorScheme.primary),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.username ?? "Anonymous",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildRatingStars(review.rating ?? 0),
                    ],
                  ),
                ),
                Text(
                  review.timestamp != null
                      ? _formatDate(review.timestamp!)
                      : "",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Review comment
            if (review.comment != null && review.comment!.isNotEmpty)
              Text(
                review.comment!,
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddReviewSection(ThemeData theme, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Your Review",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),

        // Rating input
        Row(
          children: [
            Text("Your Rating: ", style: theme.textTheme.bodyMedium),
            SizedBox(width: 8),
            KeyControlledStatefulBuilder(
              key: _ratingKey,
              builder: (context, setState) {
                return RatingBar.builder(
                  initialRating: _userRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 30,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _userRating = rating;
                    });
                  },
                );
              },
            ),
            // StatefulBuilder(
            //   key: _key,
            //   builder: (context, setState) {
            //     return RatingBar.builder(
            //       initialRating: _userRating,
            //       minRating: 1,
            //       direction: Axis.horizontal,
            //       allowHalfRating: false,
            //       itemCount: 5,
            //       itemSize: 30,
            //       itemBuilder: (context, _) => Icon(
            //         Icons.star,
            //         color: Colors.amber,
            //       ),
            //       onRatingUpdate: (rating) {
            //         setState(() {
            //           _userRating = rating;
            //         });
            //       },
            //     );
            //   }
            // ),
          ],
        ),
        SizedBox(height: 16),

        // Review text input
        TextField(
          controller: _reviewController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "Write your review here...",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),

        // Submit button
        StatefulBuilder(
          builder: (context, setState) {
            return Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  if(_isReviewing) return;
                  if (_userRating == 0) {
                    NotificationService.showFixedWidthSnackbar(
                      context,
                      "Please select a rating",
                    );
                    return;
                  }

                  setState(() => _isReviewing = true);

                  try {
                    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);

                    await reviewProvider.addReview(
                      productId: product.id!,
                      rating: _userRating,
                      comment: _reviewController.text,
                    );


                    // Reset form
                    _reviewController.clear();
                    _ratingKey.currentState!.refresh();
                    setState(() {
                      _userRating = 0;
                      _isReviewing = false;
                    });

                    NotificationService.showFixedWidthSnackbar(
                        context,
                        "Review submitted successfully!"
                    );
                  } catch (e) {
                    setState(() => _isReviewing = false);
                    NotificationService.showFixedWidthSnackbar(
                      context,
                      "Failed to submit review: ${e.toString()}",
                    );
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: _isReviewing
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Submit Review"),
              ),
            );
          }
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
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


class KeyControlledStatefulBuilder extends StatefulWidget {
  final GlobalKey<_KeyControlledStatefulBuilderState>? key;
  final Widget Function(BuildContext context, StateSetter setState) builder;

  const KeyControlledStatefulBuilder({
    this.key,
    required this.builder,
  }) : super(key: key);

  @override
  _KeyControlledStatefulBuilderState createState() =>
      _KeyControlledStatefulBuilderState();
}

class _KeyControlledStatefulBuilderState
    extends State<KeyControlledStatefulBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, setState);
  }

  void refresh() {
    setState(() {});
  }
}
