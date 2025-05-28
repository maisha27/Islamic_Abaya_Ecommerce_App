import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_model.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add to wishlist
  Future<bool> addToWishlist(String productId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .set({
        'productId': productId,
        'addedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Error adding to wishlist: $e');
      return false;
    }
  }

  // Remove from wishlist
  Future<bool> removeFromWishlist(String productId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .delete();

      return true;
    } catch (e) {
      print('Error removing from wishlist: $e');
      return false;
    }
  }

  // Get wishlisted products
  Future<List<Product>> getWishlistedProducts() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      // Get wishlist documents
      final wishlistSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .get();

      if (wishlistSnapshot.docs.isEmpty) return [];

      // Get all product IDs from wishlist
      final productIds = wishlistSnapshot.docs.map((doc) => doc.id).toList();

      // Fetch products from products collection
      final productsSnapshot = await _firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      return productsSnapshot.docs.map((doc) {
        Product product = Product.fromFirestore(doc);
        product.isWishlisted = true; // Since these are from wishlist
        return product;
      }).toList();
    } catch (e) {
      print('Error getting wishlisted products: $e');
      return [];
    }
  }

  // Check if product is wishlisted
  Future<bool> isProductWishlisted(String productId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final docSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId)
          .get();

      return docSnapshot.exists;
    } catch (e) {
      print('Error checking wishlist status: $e');
      return false;
    }
  }
}