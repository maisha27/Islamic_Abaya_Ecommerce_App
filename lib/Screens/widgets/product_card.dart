import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';
import '/Screens/product_model.dart'; // Add this import

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final bool isWishlisted;
  final Product product; // Add this
  final VoidCallback? onWishlistTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.product, // Add this
    this.isWishlisted = false,
    this.onWishlistTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.quick,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleWishlistTap() async {
    _controller.forward().then((_) => _controller.reverse());
    widget.onWishlistTap?.call();
  }

  void _handleProductTap() {
    try {
      Get.toNamed(
        '/product-details/${widget.product.id}',
        arguments: {'product': widget.product},
      );
    } catch (e) {
      print('Navigation error: $e');
      Get.snackbar(
        'Error',
        'Could not open product details',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleProductTap, // Update this
      child: Container(
        width: 160,
        constraints: const BoxConstraints(
          minHeight: 300,
          maxHeight: 400,
        ),
        margin: const EdgeInsets.only(right: AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Wishlist Button
            Stack(
              children: [
                // Product Image
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusL),
                    ),
                    child: Hero( // Add Hero widget for smooth transition
                      tag: 'product_${widget.product.id}', // Unique tag for each product
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Wishlist Button
                Positioned(
                  top: AppDimensions.paddingS,
                  right: AppDimensions.paddingS,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: _handleWishlistTap,
                        child: Icon(
                          widget.isWishlisted 
                            ? Icons.favorite 
                            : Icons.favorite_border,
                          size: 20,
                          color: widget.isWishlisted 
                            ? AppColors.accent 
                            : AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.title,
                      style: AppTextStyles.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.paddingS),
                    
                    // Price
                    Text(
                      widget.price,
                      style: AppTextStyles.price.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}