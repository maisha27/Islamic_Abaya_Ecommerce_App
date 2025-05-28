import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/Screens/widgets/custom_app_bar.dart';
import 'package:islamic_store/Screens/widgets/custom_bottom_nav.dart';
import 'package:islamic_store/controllers/cart_controller.dart';
import '../constants/app_constants.dart';



class CartScreen extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  CartScreen({Key? key}) : super(key: key);

  void _showAddressDialog() {
    final TextEditingController addressController = TextEditingController(
      text: cartController.shippingAddress.value,
    );

    Get.dialog(
      AlertDialog(
        title: Text(
          'Edit Shipping Address',
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: addressController,
          decoration: InputDecoration(
            hintText: 'Enter your shipping address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
          maxLines: 3,
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
            onPressed: () => cartController.updateShippingAddress(
              addressController.text,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            child: Text(
              'Save',
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Your Cart',
        showLogo: false, // Don't show logo since we're showing title
        showSearchIcon: true, // Keep search functionality
        showCart: true, // Keep cart access
      ),
      body: Obx(
        () => cartController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Shipping Address Section
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Shipping Address',
                                style: AppTextStyles.subtitle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppDimensions.paddingS),
                              Text(
                                cartController.shippingAddress.value,
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: AppColors.primary,
                          ),
                          onPressed: _showAddressDialog,
                        ),
                      ],
                    ),
                  ),

                  // Cart Items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppDimensions.paddingL),
                      itemCount: cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartController.cartItems[index];
                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: AppDimensions.paddingL,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusL,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  // Product Image
                                  ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(AppDimensions.radiusL),
                                    bottomLeft: Radius.circular(AppDimensions.radiusL),
                                  ),
                                    child: Image.network(
                                          item.product?.imageUrl ?? item.imageUrl, // Use either product or direct imageUrl
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                   ),
                                  const SizedBox(width: AppDimensions.paddingL),
                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product?.title ?? item.title, // Use either product or direct title
                                          style: AppTextStyles.subtitle.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: AppDimensions.paddingS),
                                        Text(
                                          '${item.selectedColor}, Size ${item.selectedSize}',
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.textLight,
                                          ),
                                        ),
                                        const SizedBox(height: AppDimensions.paddingM),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${(item.product?.price ?? item.price).toStringAsFixed(2)}',
                                              style: AppTextStyles.price.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            // Quantity Controls
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.border,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  AppDimensions.radiusM,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.remove,
                                                      color: AppColors.primary,
                                                    ),
                                                    onPressed: () =>
                                                        cartController
                                                            .updateQuantity(
                                                      item.id,
                                                      item.quantity - 1,
                                                    ),
                                                  ),
                                                  Text(
                                                    item.quantity.toString(),
                                                    style: AppTextStyles.body,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.add,
                                                      color: AppColors.primary,
                                                    ),
                                                    onPressed: () =>
                                                        cartController
                                                            .updateQuantity(
                                                      item.id,
                                                      item.quantity + 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Delete Button
                              Positioned(
                                top: AppDimensions.paddingS,
                                right: AppDimensions.paddingS,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () => cartController
                                      .removeFromCart(item.id),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Total and Checkout
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                            Text(
                              '\$${cartController.total.value.toStringAsFixed(2)}',
                              style: AppTextStyles.headline.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: cartController.cartItems.isEmpty
                              ? null
                              : () {
                                  // Navigate to checkout page
                                  Get.toNamed('/checkout');
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingXL,
                              vertical: AppDimensions.paddingL,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusL,
                              ),
                            ),
                          ),
                          child: Text(
                            'Checkout',
                            style: AppTextStyles.buttonText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Navigation Bar
                  const CustomBottomNav(),
                ],
              ),
      ),
    );
  }
}