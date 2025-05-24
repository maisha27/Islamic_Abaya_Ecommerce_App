import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String price;
  final bool isWishlisted;
  final VoidCallback? onTap;
  final VoidCallback? onWishlistTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.isWishlisted = false,
    this.onTap,
    this.onWishlistTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late bool _isWishlisted;

  @override
  void initState() {
    super.initState();
    _isWishlisted = widget.isWishlisted;
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
    setState(() {
      _isWishlisted = !_isWishlisted;
    });
    
    if (_isWishlisted) {
      _controller.forward().then((_) => _controller.reverse());
    }
    
    widget.onWishlistTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 160,
        constraints: const BoxConstraints(
          minHeight: 300,  // Minimum height for the card
          maxHeight: 400,  // Maximum height for the card
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
                  aspectRatio: 1,  // Square aspect ratio for image
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppDimensions.radiusL),
                      ),
                      image: DecorationImage(
                        image: AssetImage(widget.imageUrl),
                        fit: BoxFit.cover,
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
                          _isWishlisted ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: _isWishlisted ? AppColors.accent : AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product Details
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.title,
                        style: AppTextStyles.productTitle,
                        maxLines: null, // Allow multiple lines
                        overflow: TextOverflow.visible, // Show all text
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
            ),
          ],
        ),
      ),
    );
  }
}