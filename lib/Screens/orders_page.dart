import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:islamic_store/Screens/cart_item_model.dart';
import 'package:islamic_store/Screens/widgets/custom_app_bar.dart';
import 'package:islamic_store/Screens/widgets/custom_bottom_nav.dart';
import 'package:islamic_store/constants/app_constants.dart';
import 'package:islamic_store/Screens/checkout_model.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  Stream<QuerySnapshot> _getOrdersStream() {
    // Use Firebase Auth to get current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Return empty stream if no user is logged in
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // First check if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: 'My Orders',
          showLogo: false,
          showSearchIcon: true,
          showCart: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 64,
                color: AppColors.textLight,
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Text(
                'Please login to view your orders',
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              ElevatedButton(
                onPressed: () => Get.toNamed('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXL,
                    vertical: AppDimensions.paddingM,
                  ),
                ),
                child: Text(
                  'Login',
                  style: AppTextStyles.buttonText,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNav(),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Orders',
        showLogo: false,
        showSearchIcon: true,
        showCart: true,
      ),
      body: _buildOrdersList(),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }

  Widget _buildOrdersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getOrdersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Text(
                  'Something went wrong',
                  style: AppTextStyles.body.copyWith(color: AppColors.error),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                ElevatedButton(
                  onPressed: () {
                    // Refresh the page
                    Get.offAndToNamed('/orders');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.accent,
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Text(
                  'Loading orders...',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 64,
                  color: AppColors.textLight,
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Text(
                  'No orders yet',
                  style: AppTextStyles.subtitle.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                  ),
                  child: const Text('Start Shopping'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            try {
              final doc = snapshot.data!.docs[index];
              final order = CheckoutModel.fromFirestore(doc);
              return _buildOrderCard(order);
            } catch (e) {
              // Handle any errors parsing individual orders
              return Card(
                margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  child: Text(
                    'Error loading order',
                    style: AppTextStyles.body.copyWith(color: AppColors.error),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildOrderCard(CheckoutModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () => _showOrderDetails(order),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: AppTextStyles.subtitle,
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),
              _buildInfoRow('Order Date:', _formatDate(order.createdAt)),
              _buildInfoRow('Items:', '${order.items.length} items'),
              _buildInfoRow('Total:', '\$${order.total.toStringAsFixed(2)}'),
              const Divider(height: AppDimensions.paddingL),
              Row(
                children: [
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 16,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Text(
                    'Estimated Delivery: ${order.estimatedDeliveryDate.split(' ')[0]}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'processing':
        chipColor = Colors.blue;
        break;
      case 'shipped':
        chipColor = Colors.purple;
        break;
      case 'delivered':
        chipColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Text(
        status,
        style: AppTextStyles.caption.copyWith(
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return 'N/A';
    }
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  void _showOrderDetails(CheckoutModel order) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order Details',
                style: AppTextStyles.subheadline,
              ),
              const SizedBox(height: AppDimensions.paddingL),
              _buildDetailSection('Order Information', [
                _buildDetailRow('Order ID:', order.id),
                _buildDetailRow('Date:', _formatDate(order.createdAt)),
                _buildDetailRow('Status:', order.status),
                _buildDetailRow('Payment Method:', order.paymentMethod),
                _buildDetailRow('Payment Status:', order.paymentStatus),
              ]),
              const SizedBox(height: AppDimensions.paddingL),
              _buildDetailSection('Delivery Information', [
                _buildDetailRow('Address:', order.shippingAddress),
                _buildDetailRow('Phone:', order.phoneNumber),
                _buildDetailRow('Estimated Delivery:', 
                    order.estimatedDeliveryDate.split(' ')[0]),
              ]),
              const SizedBox(height: AppDimensions.paddingL),
              _buildDetailSection('Order Summary', [
                ...order.items.map((item) => _buildOrderItemRow(item)),
                const Divider(height: AppDimensions.paddingL),
                _buildDetailRow('Subtotal:', '\$${order.subtotal.toStringAsFixed(2)}'),
                _buildDetailRow('Tax:', '\$${order.tax.toStringAsFixed(2)}'),
                _buildDetailRow('Shipping:', '\$${order.shippingCost.toStringAsFixed(2)}'),
                _buildDetailRow('Total:', '\$${order.total.toStringAsFixed(2)}', 
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: AppDimensions.paddingL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: AppDimensions.paddingM),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: style ?? AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildOrderItemRow(CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            child: Image.network(
              item.imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 40,
                  height: 40,
                  color: AppColors.background,
                  child: Icon(
                    Icons.image_not_supported,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 40,
                  height: 40,
                  color: AppColors.background,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accent,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${item.price.toStringAsFixed(2)} × ${item.quantity}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}