import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/Screens/widgets/custom_app_bar.dart';
import 'package:islamic_store/Screens/widgets/custom_bottom_nav.dart';
import '../constants/app_constants.dart';
import 'cart_service.dart';
import 'product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartService _cartService = CartService();
  int quantity = 1;
  String selectedSize = 'M';
  String selectedColor = 'Black';

  final List<String> sizes = ['S', 'M', 'L', 'XL'];
  final List<Color> colors = [
    Colors.black,
    Colors.grey,
    Colors.brown,
  ];

  void _incrementQuantity() {
    setState(() {
      if (quantity < 10) quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 1) quantity--;
    });
  }

  Future<void> _addToCart() async {
    try {
      final success = await _cartService.addToCart(
        productId: widget.product.id,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Added to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Product Details',
        showLogo: false, // Don't show logo since we're showing title
        showSearchIcon: true, // Keep search functionality
        showCart: true, // Keep cart access
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: Image.network(
                widget.product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.title,
                          style: AppTextStyles.headline.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: AppColors.primary),
                              onPressed: _decrementQuantity,
                            ),
                            Text(
                              quantity.toString(),
                              style: AppTextStyles.body,
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: AppColors.primary),
                              onPressed: _incrementQuantity,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.paddingL),

                  // Description
                  Text(
                    'Description',
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  Text(
                    widget.product.description,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingXL),

                  // Sizes and Colors
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sizes Section
                      Text(
                        'Choose Size',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      Wrap(
                        spacing: AppDimensions.paddingS,
                        children: sizes.map((size) {
                          final isSelected = selectedSize == size;
                          return GestureDetector(
                            onTap: () => setState(() => selectedSize = size),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingM,
                                vertical: AppDimensions.paddingS,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                ),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                              ),
                              child: Text(
                                size,
                                style: AppTextStyles.body.copyWith(
                                  color: isSelected ? Colors.white : AppColors.text,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: AppDimensions.paddingL),

                      // Colors Section
                      Text(
                        'Color',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      Row(
                        children: colors.map((color) {
                          final isSelected = selectedColor == color.toString();
                          return GestureDetector(
                            onTap: () => setState(() => selectedColor = color.toString()),
                            child: Container(
                              margin: const EdgeInsets.only(right: AppDimensions.paddingS),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add to Cart Section
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      Text(
                        'Add to Cart',
                        style: AppTextStyles.buttonText.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          
                        ),
                      ),
                      const SizedBox(width: 80),
                    ],
                  ),
                  Positioned(
                    right: AppDimensions.paddingL,
                    child: Text(
                      '\$${(widget.product.price * quantity).toStringAsFixed(2)}',
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Navigation Bar
          const CustomBottomNav(),
        ],
      ),
    );
  }
}