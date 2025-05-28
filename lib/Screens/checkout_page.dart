import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/Screens/cart_item_model.dart';
import 'package:islamic_store/Screens/widgets/custom_app_bar.dart';
import 'package:islamic_store/constants/app_constants.dart';
import '../controllers/checkout_controller.dart';


class CheckoutPage extends GetView<CheckoutController> {
  const CheckoutPage({Key? key}) : super(key: key);


   void _editShippingAddress() {
  final textController = TextEditingController();
  textController.text = controller.shippingAddress.value; // Pre-fill existing address

  Get.dialog(
    AlertDialog(
      title: Text('Update Shipping Address', style: AppTextStyles.subtitle),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          hintText: 'Enter your shipping address',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            controller.updateShippingAddress(value);
            Get.back();
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              controller.updateShippingAddress(textController.text);
              Get.back();
            }
          },
          child: const Text('Update'),
        ),
      ],
    ),
  ).whenComplete(() => textController.dispose()); // Dispose the controller when done
}

void _editPhoneNumber() {
  final textController = TextEditingController();
  textController.text = controller.phoneNumber.value; // Changed from contactInfo

  Get.dialog(
    AlertDialog(
      title: Text('Update Phone Number', style: AppTextStyles.subtitle),
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(
          hintText: 'Enter your phone number',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone, // Add this for phone number input
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            controller.updatePhoneNumber(value); // Changed from updateContactInfo
            Get.back();
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (textController.text.isNotEmpty) {
              controller.updatePhoneNumber(textController.text); // Changed from updateContactInfo
              Get.back();
            }
          },
          child: const Text('Update'),
        ),
      ],
    ),
  ).whenComplete(() => textController.dispose());
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: const CustomAppBar(
      title: 'Checkout',
      showLogo: false,
      showSearchIcon: true,
      showCart: true,
    ),
    body: Obx(() => _buildBody()),
  );
}

  

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Shipping Address',
              content: controller.shippingAddress.value,
              onEdit: () => _editShippingAddress(),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            _buildSection(
              title: 'Contact Information',
              content: controller.phoneNumber.value,
              onEdit: () => _editPhoneNumber(),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            _buildProductsList(),
            const SizedBox(height: AppDimensions.paddingL),
            _buildPaymentMethod(),
            const SizedBox(height: AppDimensions.paddingL),
            _buildBillSummary(),
            const SizedBox(height: AppDimensions.paddingXL),
            _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.subtitle,
              ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: AppColors.accent,
                ),
                onPressed: onEdit,
              ),
            ],
          ),
          Text(
            content,
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items (${controller.cartController.cartItems.length})',
          style: AppTextStyles.subtitle,
        ),
        const SizedBox(height: AppDimensions.paddingM),
        ...controller.cartController.cartItems.map((item) => _buildProductItem(item)),
      ],
    );
  }

  Widget _buildProductItem(CartItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
            child: Image.network(
              item.imageUrl,
              width: 60,
              height: 60,
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Method',
              style: AppTextStyles.subtitle,
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: AppColors.accent,
              ),
              onPressed: () => _showPaymentMethodSelector(),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingM),
        Container(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(
                controller.selectedPaymentMethod.value == 'Card'
                    ? Icons.credit_card
                    : Icons.money,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Text(
                controller.selectedPaymentMethod.value,
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillSummary() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBillRow('Subtotal', controller.subtotal),
          _buildBillRow('Tax', controller.tax),
          _buildBillRow('Shipping', controller.shippingCost),
          const Divider(height: AppDimensions.paddingL),
          _buildBillRow(
            'Total',
            controller.total,
             style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, double amount, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style ?? AppTextStyles.body),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: style ?? AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isProcessing.value
            ? null
            : () => controller.placeOrder(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
        child: controller.isProcessing.value
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Place Order',
                style: AppTextStyles.buttonText,
              ),
      ),
    );
  }

  void _showPaymentMethodSelector() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusL),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Payment Method',
              style: AppTextStyles.subheadline,
            ),
            const SizedBox(height: AppDimensions.paddingL),
            _buildPaymentOption('Card', Icons.credit_card),
            const SizedBox(height: AppDimensions.paddingM),
            _buildPaymentOption('Cash', Icons.money),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.accent),
      title: Text(method, style: AppTextStyles.body),
      trailing: controller.selectedPaymentMethod.value == method
          ? Icon(Icons.check_circle, color: AppColors.accent)
          : null,
      onTap: () {
        controller.selectedPaymentMethod.value = method;
        Get.back();
      },
    );
  }
}