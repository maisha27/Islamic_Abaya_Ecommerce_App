import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/Screens/product_model.dart';
import 'package:islamic_store/Screens/wishlist_service.dart';
import 'package:islamic_store/constants/app_constants.dart';

class WishlistController extends GetxController {
  final WishlistService _wishlistService = WishlistService();
  final RxList<Product> wishlistedProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWishlistedProducts();
  }

  Future<void> fetchWishlistedProducts() async {
    isLoading.value = true;
    try {
      final products = await _wishlistService.getWishlistedProducts();
      wishlistedProducts.value = products;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load wishlist items',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleWishlist(String productId) async {
    try {
      final isWishlisted = await _wishlistService.isProductWishlisted(productId);
      
      if (isWishlisted) {
        await _wishlistService.removeFromWishlist(productId);
        wishlistedProducts.removeWhere((product) => product.id == productId);
        Get.snackbar(
          'Success',
          'Item removed from wishlist',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        await _wishlistService.addToWishlist(productId);
        // Refresh the wishlist to get the newly added product
        await fetchWishlistedProducts();
        Get.snackbar(
          'Success',
          'Item added to wishlist',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update wishlist',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Helper method to remove item from wishlist (used in UI)
  Future<void> removeFromWishlist(Product product) async {
    try {
      await _wishlistService.removeFromWishlist(product.id);
      wishlistedProducts.removeWhere((p) => p.id == product.id);
      Get.snackbar(
        'Success',
        'Item removed from wishlist',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item from wishlist',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Check if a product is in wishlist
  bool isProductWishlisted(String productId) {
    return wishlistedProducts.any((product) => product.id == productId);
  }

  // Get count of wishlisted items
  int get wishlistCount => wishlistedProducts.length;

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}