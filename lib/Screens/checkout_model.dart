import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamic_store/Screens/cart_item_model.dart';

class CheckoutModel {
  final String id;
  final String userId;
  final String shippingAddress;
  final String phoneNumber;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double total;
  final String paymentMethod;
  final String status;
  final String paymentStatus;
  final String orderDate;
  final String estimatedDeliveryDate;
  final String createdAt;

  CheckoutModel({
    required this.id,
    required this.userId,
    required this.shippingAddress,
    required this.phoneNumber,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.paymentStatus,
    required this.orderDate,
    required this.estimatedDeliveryDate,
    required this.createdAt,
  });

  factory CheckoutModel.fromFirestore(DocumentSnapshot doc) {
  final data = doc.data() as Map<String, dynamic>? ?? {};
  
  // Convert the items list from Firestore with null checking
  final itemsList = (data['items'] as List<dynamic>?)?.map((item) {
    return CartItem(
      id: item['id']?.toString() ?? '',
      productId: item['productId']?.toString() ?? '',
      title: item['title']?.toString() ?? '',
      price: double.tryParse(item['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: item['imageUrl']?.toString() ?? '',
      quantity: int.tryParse(item['quantity']?.toString() ?? '1') ?? 1,
      selectedSize: item['selectedSize']?.toString() ?? '',
      selectedColor: item['selectedColor']?.toString() ?? '',
      addedAt: item['addedAt'] != null 
          ? (item['addedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }).toList() ?? [];

  return CheckoutModel(
    id: doc.id,
    userId: data['userId']?.toString() ?? '',
    shippingAddress: data['shippingAddress']?.toString() ?? '',
    phoneNumber: data['phoneNumber']?.toString() ?? '',
    items: itemsList,
    subtotal: double.tryParse(data['subtotal']?.toString() ?? '0') ?? 0.0,
    tax: double.tryParse(data['tax']?.toString() ?? '0') ?? 0.0,
    shippingCost: double.tryParse(data['shippingCost']?.toString() ?? '0') ?? 0.0,
    total: double.tryParse(data['total']?.toString() ?? '0') ?? 0.0,
    paymentMethod: data['paymentMethod']?.toString() ?? 'Not specified',
    status: data['status']?.toString() ?? 'Pending',
    paymentStatus: data['paymentStatus']?.toString() ?? 'Pending',
    orderDate: data['orderDate']?.toString() ?? DateTime.now().toUtc().toString(),
    estimatedDeliveryDate: data['estimatedDeliveryDate']?.toString() ?? 
        DateTime.now().add(const Duration(days: 7)).toUtc().toString(),
    createdAt: data['createdAt']?.toString() ?? DateTime.now().toUtc().toString(),
  );
}
  Map<String, dynamic> toJson() => {
        'orderId': id,
        'userId': userId,
        'shippingAddress': shippingAddress,
        'phoneNumber': phoneNumber,
        'items': items.map((item) => item.toFirestore()).toList(),
        'subtotal': subtotal,
        'tax': tax,
        'shippingCost': shippingCost,
        'total': total,
        'paymentMethod': paymentMethod,
        'status': status,
        'paymentStatus': paymentStatus,
        'orderDate': orderDate,
        'estimatedDeliveryDate': estimatedDeliveryDate,
        'createdAt': createdAt,
      };

  // Optional: Add a copyWith method for easier object modification
  CheckoutModel copyWith({
    String? id,
    String? userId,
    String? shippingAddress,
    String? phoneNumber,
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? shippingCost,
    double? total,
    String? paymentMethod,
    String? status,
    String? paymentStatus,
    String? orderDate,
    String? estimatedDeliveryDate,
    String? createdAt,
  }) {
    return CheckoutModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      shippingCost: shippingCost ?? this.shippingCost,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderDate: orderDate ?? this.orderDate,
      estimatedDeliveryDate: estimatedDeliveryDate ?? this.estimatedDeliveryDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}