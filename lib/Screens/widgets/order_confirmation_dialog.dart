import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:islamic_store/Screens/cart_item_model.dart';
import 'package:islamic_store/Screens/checkout_model.dart';
import 'package:islamic_store/constants/app_constants.dart';

class OrderConfirmationDialog extends StatelessWidget {
  final CheckoutModel order;

  const OrderConfirmationDialog({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Text(
                'Order Confirmed!',
                style: AppTextStyles.subheadline.copyWith(
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              Text(
                'Order ID: ${order.id}',
                style: AppTextStyles.subtitle,
              ),
              const SizedBox(height: AppDimensions.paddingL),
              _buildOrderDetails(),
              const SizedBox(height: AppDimensions.paddingL),
              ElevatedButton(
              onPressed: () {
                Get.offAllNamed('/'); // Clear the stack and go to home
                Get.toNamed('/orders'); // Then navigate to orders
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXL,
                  vertical: AppDimensions.paddingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              child: Text(
                'View Orders',
                style: AppTextStyles.buttonText,
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Delivery Details'),
          _buildInfoRow(
            'Estimated Delivery:',
            order.estimatedDeliveryDate.split(' ')[0], // Show only the date part
          ),
          _buildInfoRow('Shipping Address:', order.shippingAddress),
          _buildInfoRow('Phone Number:', order.phoneNumber), // Changed from contactInfo
          const SizedBox(height: AppDimensions.paddingM),
          _buildSectionTitle('Order Summary'),
          ...order.items.map((item) => _buildOrderItem(item)),
          const Divider(height: AppDimensions.paddingL),
          _buildInfoRow('Subtotal:', '\$${order.subtotal.toStringAsFixed(2)}'),
          _buildInfoRow('Tax:', '\$${order.tax.toStringAsFixed(2)}'),
          _buildInfoRow('Shipping:', '\$${order.shippingCost.toStringAsFixed(2)}'),
          const SizedBox(height: AppDimensions.paddingS),
          _buildInfoRow(
            'Total:',
            '\$${order.total.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          _buildInfoRow('Payment Method:', order.paymentMethod),
          _buildInfoRow('Order Status:', order.status), // Added order status
          _buildInfoRow('Payment Status:', order.paymentStatus), // Added payment status
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Text(
        title,
        style: AppTextStyles.subtitle,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: style ?? AppTextStyles.body,
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

  Widget _buildOrderItem(CartItem item) {
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