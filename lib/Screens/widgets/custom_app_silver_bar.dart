import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/constants/app_constants.dart';
import 'package:islamic_store/Screens/search_delegate.dart';

class CustomSliverAppBar extends StatelessWidget {
  final bool floating;
  final bool pinned;
  final double expandedHeight;
  
  const CustomSliverAppBar({
    Key? key,
    this.floating = true,
    this.pinned = false,
    this.expandedHeight = kToolbarHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: floating,
      pinned: pinned,
      expandedHeight: expandedHeight,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/logo.png'),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: AppColors.primary,
          ),
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.primary,
          ),
          onPressed: () => Get.toNamed('/cart'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}