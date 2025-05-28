import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';

class CartItem {
  final String id;
  final String productId;
  final Product? product; // Optional product
  final String title;
  final double price;
  final String imageUrl;
  int quantity;
  String selectedSize;
  String selectedColor;
  DateTime addedAt;

  CartItem({
    required this.id,
    required this.productId,
    this.product,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedColor,
    required this.addedAt,
  });

  // Create from Firestore with Product object
  factory CartItem.fromFirestoreWithProduct(DocumentSnapshot doc, Product product) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      productId: product.id,
      product: product,
      title: product.title,
      price: product.price,
      imageUrl: product.imageUrl,
      quantity: data['quantity'] ?? 1,
      selectedSize: data['selectedSize'] ?? '',
      selectedColor: data['selectedColor'] ?? '',
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }

  // Create from Firestore without Product object
  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      productId: data['productId'] ?? '',
      title: data['title'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      quantity: data['quantity'] ?? 1,
      selectedSize: data['selectedSize'] ?? '',
      selectedColor: data['selectedColor'] ?? '',
      addedAt: (data['addedAt'] as Timestamp).toDate(),
    );
  }

  // For Firestore storage
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  // For order creation (more detailed for order records)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'totalPrice': totalPrice,
      'addedAt': addedAt.toIso8601String(),
      'productDetails': product?.toJson(), // Include if available
    };
  }

  CartItem copyWith({
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      id: id,
      productId: productId,
      product: product,
      title: title,
      price: price,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      addedAt: addedAt,
    );
  }

  double get totalPrice => price * quantity;
}