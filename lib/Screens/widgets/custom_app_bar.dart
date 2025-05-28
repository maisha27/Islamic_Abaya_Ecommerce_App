import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/constants/app_constants.dart';
import 'package:islamic_store/Screens/search_delegate.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final bool showSearchIcon;
  final bool showCart;

  const CustomAppBar({
    Key? key,
    this.title,
    this.showLogo = true,
    this.showSearchIcon = true,
    this.showCart = true,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: showLogo 
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/logo.png'),
            )
          : null,
      title: title != null 
          ? Text(
              title!,
              style: AppTextStyles.subtitle.copyWith(
                color: AppColors.primary,
              ),
            )
          : null,
      actions: [
        if (showSearchIcon)
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
        if (showCart)
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