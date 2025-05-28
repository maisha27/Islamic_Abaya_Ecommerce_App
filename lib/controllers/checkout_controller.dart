import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import
import 'package:islamic_store/Screens/widgets/order_confirmation_dialog.dart';
import 'package:islamic_store/constants/app_constants.dart';
import 'package:islamic_store/controllers/cart_controller.dart';
import 'package:islamic_store/Screens/checkout_model.dart'; // Add this import

class CheckoutController extends GetxController {
  final cartController = Get.find<CartController>();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  
  final Rx<String> selectedPaymentMethod = 'Card'.obs;
  final RxBool isProcessing = false.obs;
  final RxBool isLoading = true.obs;
  
  final RxString shippingAddress = ''.obs;
  final RxString phoneNumber = ''.obs;

  // Get current user ID
  String get currentUserId => _auth.currentUser?.uid ?? '';

  double get subtotal => cartController.subtotal;
  double get tax => subtotal * 0.1;
  double get shippingCost => 5.0;
  double get total => subtotal + tax + shippingCost;

  @override
  void onInit() {
    super.onInit();
    if (currentUserId.isNotEmpty) {
      fetchUserDetails();
    } else {
      Get.offAllNamed('/login'); // Redirect to login if no user
    }
  }

  Future<void> fetchUserDetails() async {
    try {
      isLoading.value = true;
      
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          shippingAddress.value = data['shippingAddress'] ?? '';
          phoneNumber.value = data['phoneNumber'] ?? '';
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load user details. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateShippingAddress(String address) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .update({
        'shippingAddress': address,
        'updatedAt': '2025-05-26 05:50:53',
      });

      shippingAddress.value = address;
      
      Get.snackbar(
        'Success',
        'Shipping address updated successfully',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update shipping address. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updatePhoneNumber(String phone) async {
    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .update({
        'phoneNumber': phone,
        'updatedAt': '2025-05-26 05:50:53',
      });

      phoneNumber.value = phone;
      
      Get.snackbar(
        'Success',
        'Phone number updated successfully',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update phone number. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> placeOrder() async {
    try {
      if (currentUserId.isEmpty) {
        Get.offAllNamed('/login');
        return;
      }

      if (shippingAddress.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Please add shipping address before placing order',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }

      if (phoneNumber.value.isEmpty) {
        Get.snackbar(
          'Error',
          'Please verify your phone number before placing order',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }

      isProcessing.value = true;
      
      final orderId = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create CheckoutModel instance
      final order = CheckoutModel(
        id: orderId,
        userId: currentUserId,
        items: cartController.cartItems,
        subtotal: subtotal,
        tax: tax,
        shippingCost: shippingCost,
        total: total,
        shippingAddress: shippingAddress.value,
        phoneNumber: phoneNumber.value,
        paymentMethod: selectedPaymentMethod.value,
        status: 'pending',
        paymentStatus: 'pending',
        orderDate: '2025-05-26 05:50:53',
        estimatedDeliveryDate: '2025-05-31 05:50:53',
        createdAt: '2025-05-26 05:50:53',
      );

      // Save order to Firestore
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('orders')
          .doc(orderId)
          .set(order.toJson());

      // Clear cart after successful order
      await cartController.clearCart();
      
      // Show success dialog with CheckoutModel
      _showOrderConfirmation(order);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to place order. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void _showOrderConfirmation(CheckoutModel order) {
    Get.dialog(
      OrderConfirmationDialog(order: order),
      barrierDismissible: false,
    );
  }

  bool get canProceedToCheckout {
    return currentUserId.isNotEmpty &&
           !isProcessing.value && 
           !isLoading.value && 
           cartController.cartItems.isNotEmpty &&
           shippingAddress.value.isNotEmpty &&
           phoneNumber.value.isNotEmpty;
  }
}