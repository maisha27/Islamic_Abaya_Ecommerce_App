import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/Screens/widgets/custom_app_bar.dart';
import 'package:islamic_store/Screens/widgets/custom_bottom_nav.dart';
import 'package:islamic_store/constants/app_constants.dart';
import 'package:islamic_store/controllers/wishlist_controller.dart';
import 'package:islamic_store/Screens/product_model.dart';


class WishlistPage extends GetView<WishlistController> {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Wishlist',
        showLogo: false, // Don't show logo since we're showing title
        showSearchIcon: true, // Keep search functionality
        showCart: true, // Keep cart access
      ),
      body: _buildBody(),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }

  

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.accent,
          ),
        );
      }

      if (controller.wishlistedProducts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                size: 64,
                color: AppColors.accent,
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Text(
                'Your wishlist is empty',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                'Add items you love to your wishlist',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              ElevatedButton(
                onPressed: () => Get.offAllNamed('/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL,
                    vertical: AppDimensions.paddingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                child: Text(
                  'Start Shopping',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: AppDimensions.paddingM,
          mainAxisSpacing: AppDimensions.paddingM,
        ),
        itemCount: controller.wishlistedProducts.length,
        itemBuilder: (context, index) {
          final product = controller.wishlistedProducts[index];
          return _buildProductCard(product);
        },
      );
    });
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/product-details/${product.id}',
        arguments: {'product': product},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Love Icon
            Expanded(
              flex: 3, // Adjust the ratio of image to content
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusM),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.background,
                            child: Icon(
                              Icons.image_not_supported,
                              color: AppColors.textLight,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppDimensions.paddingS,
                    right: AppDimensions.paddingS,
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: AppColors.accent,
                      ),
                      onPressed: () => controller.removeFromWishlist(product),
                    ),
                  ),
                ],
              ),
            ),
            // Product Details
            Expanded(
              flex: 2, // Adjust the ratio of image to content
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        product.title,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          onPressed: () => _showDeleteConfirmation(product),
                        ),
                      ],
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


  void _showDeleteConfirmation(Product product) {
    Get.dialog(
      AlertDialog(
        title: Text('Remove from Wishlist', style: AppTextStyles.subtitle),
        content: Text(
          'Are you sure you want to remove this item from your wishlist?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.removeFromWishlist(product);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}