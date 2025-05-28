import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_item_model.dart';
import 'product_service.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProductService _productService = ProductService();

  Future<bool> addToCart({
    required String productId,
    required int quantity,
    required String selectedSize,
    required String selectedColor,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      // Get product details
      final product = await _productService.getProductDetails(productId);
      if (product == null) return false;

      // Check if item already exists in cart with same size and color
      final existingItemQuery = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .where('productId', isEqualTo: productId)
          .where('selectedSize', isEqualTo: selectedSize)
          .where('selectedColor', isEqualTo: selectedColor)
          .get();

      if (existingItemQuery.docs.isNotEmpty) {
        // Update existing item quantity
        final existingDoc = existingItemQuery.docs.first;
        final currentQuantity = existingDoc.data()['quantity'] ?? 0;
        await existingDoc.reference.update({
          'quantity': currentQuantity + quantity,
        });
      } else {
        // Create new cart item
        final cartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.id,
          product: product,
          title: product.title,
          price: product.price,
          imageUrl: product.imageUrl,
          quantity: quantity,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
          addedAt: DateTime.now(),
        );

        // Add to cart collection
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(cartItem.id)
            .set(cartItem.toFirestore());
      }

      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  // Watch cart items in real-time
  Stream<List<CartItem>> watchCartItems() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartItem.fromFirestore(doc))
            .toList());
  }

  // Update item quantity
  Future<bool> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      if (newQuantity < 1) return false;

      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .update({'quantity': newQuantity});

      return true;
    } catch (e) {
      print('Error updating quantity: $e');
      return false;
    }
  }

  // Remove item from cart
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartItemId)
          .delete();

      return true;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Clear entire cart
  Future<bool> clearCart() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final cartSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      final batch = _firestore.batch();
      for (var doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  // Get cart item count
  Future<int> getCartItemCount() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return 0;

      final cartSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('cart')
          .get();

      return cartSnapshot.docs.length;
    } catch (e) {
      print('Error getting cart count: $e');
      return 0;
    }
  }

  // Get shipping address
  Future<String> getShippingAddress() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return '';

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      return doc.data()?['shippingAddress'] ?? '';
    } catch (e) {
      print('Error getting shipping address: $e');
      return '';
    }
  }

  // Update shipping address
  Future<bool> updateShippingAddress(String address) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore
          .collection('users')
          .doc(userId)
          .update({'shippingAddress': address});

      return true;
    } catch (e) {
      print('Error updating shipping address: $e');
      return false;
    }
  }
}