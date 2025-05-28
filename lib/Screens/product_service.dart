import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch new arrivals
  Future<List<Product>> getNewArrivals() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      final List<Product> products = [];
      final Set<String> wishlistedProducts = await getUserWishlist();

      for (var doc in snapshot.docs) {
        // Create product from document
        final product = Product.fromFirestore(doc);
        // Update wishlist status
        product.isWishlisted = wishlistedProducts.contains(product.id);
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error fetching new arrivals: $e');
      return [];
    }
  }

  // Fetch best sellers
  Future<List<Product>> getBestSellers() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .orderBy('soldCount', descending: true)
          .limit(10)
          .get();

      final List<Product> products = [];
      final Set<String> wishlistedProducts = await getUserWishlist();

      for (var doc in snapshot.docs) {
        // Create product from document
        final product = Product.fromFirestore(doc);
        // Update wishlist status
        product.isWishlisted = wishlistedProducts.contains(product.id);
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error fetching best sellers: $e');
      return [];
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      final List<Product> products = [];
      final Set<String> wishlistedProducts = await getUserWishlist();

      for (var doc in snapshot.docs) {
        final product = Product.fromFirestore(doc);
        product.isWishlisted = wishlistedProducts.contains(product.id);
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Get product details
  Future<Product?> getProductDetails(String productId) async {
    try {
      final DocumentSnapshot doc = await _firestore
          .collection('products')
          .doc(productId)
          .get();

      if (!doc.exists) {
        print('Product not found: $productId');
        return null;
      }

      // Create product from document
      final product = Product.fromFirestore(doc);
      
      // Update wishlist status
      final Set<String> wishlistedProducts = await getUserWishlist();
      product.isWishlisted = wishlistedProducts.contains(product.id);

      return product;
    } catch (e) {
      print('Error fetching product details: $e');
      return null;
    }
  }

  // Get user's wishlisted products
  Future<List<Product>> getWishlistedProducts() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      // Get all wishlist documents
      final QuerySnapshot wishlistSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .get();

      if (wishlistSnapshot.docs.isEmpty) return [];

      // Get all product IDs from wishlist
      final List<String> productIds = wishlistSnapshot.docs
          .map((doc) => doc.id)
          .toList();

      // Fetch all products in wishlist
      final QuerySnapshot productsSnapshot = await _firestore
          .collection('products')
          .where(FieldPath.documentId, whereIn: productIds)
          .get();

      return productsSnapshot.docs.map((doc) {
        final product = Product.fromFirestore(doc);
        product.isWishlisted = true; // These are from wishlist, so they're wishlisted
        return product;
      }).toList();
    } catch (e) {
      print('Error fetching wishlisted products: $e');
      return [];
    }
  }

  // Toggle wishlist status
  Future<bool> toggleWishlist(String productId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        print('User not logged in');
        return false;
      }

      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(productId);

      final doc = await docRef.get();

      if (doc.exists) {
        // Remove from wishlist
        await docRef.delete();
        print('Product removed from wishlist: $productId');
        return false; // Returns false to indicate item is not wishlisted
      } else {
        // Add to wishlist
        await docRef.set({
          'addedAt': FieldValue.serverTimestamp(),
          'productId': productId,
        });
        print('Product added to wishlist: $productId');
        return true; // Returns true to indicate item is wishlisted
      }
    } catch (e) {
      print('Error toggling wishlist: $e');
      return false;
    }
  }

  // Get user's wishlist IDs
  Future<Set<String>> getUserWishlist() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return {};

      final QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .get();

      return snapshot.docs
          .map((doc) => doc.id)
          .toSet();
    } catch (e) {
      print('Error fetching user wishlist: $e');
      return {};
    }
  }

  // Listen to wishlist changes
  Stream<Set<String>> watchUserWishlist() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value({});

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }
}