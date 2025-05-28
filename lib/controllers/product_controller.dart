import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/constants/app_constants.dart';
import 'wishlist_controller.dart';
import '/Screens/product_model.dart';
import '/Screens/product_service.dart';


class ProductController extends GetxController {
  final ProductService _productService = ProductService();
  final WishlistController _wishlistController = Get.find<WishlistController>();

  final RxList<Product> newArrivals = <Product>[].obs;
  final RxList<Product> bestSellers = <Product>[].obs;
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHomePageProducts();
  }

  Future<void> fetchHomePageProducts() async {
    isLoading.value = true;
    try {
      final futures = await Future.wait([
        _productService.getNewArrivals(),
        _productService.getBestSellers(),
      ]);

      newArrivals.value = futures[0];
      bestSellers.value = futures[1];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load products',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProductDetails(String productId) async {
    isLoading.value = true;
    try {
      final product = await _productService.getProductDetails(productId);
      if (product != null) {
        selectedProduct.value = product;
        Get.toNamed('/product-details', arguments: product);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load product details',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleWishlist(String productId) async {
    try {
      await _wishlistController.toggleWishlist(productId);
      
      // Update product in newArrivals list
      int newArrivalsIndex = newArrivals.indexWhere((p) => p.id == productId);
      if (newArrivalsIndex != -1) {
        newArrivals[newArrivalsIndex].isWishlisted = 
          _wishlistController.wishlistedProducts.any((p) => p.id == productId);
        newArrivals.refresh();
      }

      // Update product in bestSellers list
      int bestSellersIndex = bestSellers.indexWhere((p) => p.id == productId);
      if (bestSellersIndex != -1) {
        bestSellers[bestSellersIndex].isWishlisted = 
          _wishlistController.wishlistedProducts.any((p) => p.id == productId);
        bestSellers.refresh();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update wishlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void navigateToProductDetails(Product product) {
    try {
      Get.toNamed(
        '/product-details/${product.id}',
        arguments: {'product': product},
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
}