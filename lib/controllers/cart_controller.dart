import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:islamic_store/constants/app_constants.dart';
import '/Screens/cart_item_model.dart';
import '/Screens/cart_service.dart';

class CartController extends GetxController {
  final CartService _cartService = CartService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxString shippingAddress = ''.obs;
  final RxString contactInfo = ''.obs; // Added for checkout
  final RxBool isLoading = false.obs;
  final RxDouble total = 0.0.obs;

  // Getters for checkout calculations
  double get subtotal => total.value;
  double get tax => subtotal * 0.1; // 10% tax
  double get shippingCost => 5.0; // Fixed shipping cost
  double get totalWithTaxAndShipping => subtotal + tax + shippingCost;

  @override
  void onInit() {
    super.onInit();
    _listenToCartChanges();
    fetchCartDetails();
  }

  void _listenToCartChanges() {
    _cartService.watchCartItems().listen((items) {
      cartItems.value = items;
      _calculateTotal();
    });
  }

  // Updated to fetch both shipping address and contact info
  Future<void> fetchCartDetails() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      final cartDetailsDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('cart_details')
          .get();

      // Get shipping address from user document (legacy support)
      final legacyAddress = userDoc.data()?['shippingAddress'];
      
      if (cartDetailsDoc.exists) {
        final cartData = cartDetailsDoc.data();
        shippingAddress.value = cartData?['shippingAddress'] ?? legacyAddress ?? '';
        contactInfo.value = cartData?['contactInfo'] ?? '';
      } else {
        shippingAddress.value = legacyAddress ?? '';
      }
    } catch (e) {
      print('Error fetching cart details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateShippingAddress(String address) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Update in both places for consistency
      await Future.wait([
        _firestore
            .collection('users')
            .doc(userId)
            .update({'shippingAddress': address}),
        
        _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc('cart_details')
            .set({
              'shippingAddress': address,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true))
      ]);

      shippingAddress.value = address;
      Get.back(); // Close dialog
      Get.snackbar(
        'Success',
        'Shipping address updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating shipping address: $e');
      Get.snackbar(
        'Error',
        'Failed to update shipping address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateContactInfo(String contact) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc('cart_details')
          .set({
            'contactInfo': contact,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      contactInfo.value = contact;
      Get.back(); // Close dialog
      Get.snackbar(
        'Success',
        'Contact information updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating contact info: $e');
      Get.snackbar(
        'Error',
        'Failed to update contact information',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
    }
  }

  // Other existing methods remain the same...

  

  Future<void> removeFromCart(String cartItemId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();

      // No need to manually update cartItems as stream will handle it
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      if (newQuantity < 1) return;

      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .update({'quantity': newQuantity});

      // No need to manually update cartItems as stream will handle it
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  void _calculateTotal() {
    total.value = cartItems.fold(
      0,
      (sum, item) => sum + item.totalPrice, // Use the getter from CartItem
    );
  }

  Future<void> checkout() async {
    try {
      // TODO: Implement checkout logic
      // 1. Create order document
      // 2. Process payment
      // 3. Clear cart
      // 4. Update inventory
    } catch (e) {
      print('Error during checkout: $e');
    }
  }


Future<void> clearCart() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Get all cart items
      final cartSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      // Delete all cart items
      final batch = _firestore.batch();
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Clear cart details except shipping address
      batch.set(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc('cart_details'),
        {
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true)
      );

      await batch.commit();
    } catch (e) {
      print('Error clearing cart: $e');
      throw Exception('Failed to clear cart');
    }
  }

  // New method to check if cart is valid for checkout
  bool get isValidForCheckout {
    return cartItems.isNotEmpty && 
           shippingAddress.value.isNotEmpty && 
           contactInfo.value.isNotEmpty;
  }

  // New method to get cart data for order creation
  Map<String, dynamic> getCartDataForOrder() {
    return {
      'items': cartItems.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'shippingCost': shippingCost,
      'total': totalWithTaxAndShipping,
      'shippingAddress': shippingAddress.value,
      'contactInfo': contactInfo.value,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}