import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_store/controllers/navigation_controller.dart';
import '../../constants/app_constants.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  final NavigationController navigationController = Get.put(NavigationController());
  final ScrollController _scrollController = ScrollController();

  final List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Shop',
      route: '/home',
    ),
    _NavItem(
      icon: Icons.favorite_outline,
      selectedIcon: Icons.favorite,
      label: 'Wishlist',
      route: '/wishlist',
    ),
    _NavItem(
      icon: Icons.shopping_bag_outlined,
      selectedIcon: Icons.shopping_bag,
      label: 'Cart',
      route: '/cart',
    ),
    _NavItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Account',
      route: '/account',
    ),
    _NavItem(
      icon: Icons.support_agent_outlined,
      selectedIcon: Icons.support_agent,
      label: 'Contact',
      route: '/contact',
    ),
    _NavItem(
      icon: Icons.logout_outlined,
      selectedIcon: Icons.logout,
      label: 'Logout',
      route: '/logout',
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    final item = _navItems[index];
    
    if (item.route == '/logout') {
      _showLogoutConfirmation();
    } else {
      navigationController.changePage(index);
      Get.toNamed(item.route);
    }
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text('Logout Confirmation', style: AppTextStyles.subtitle),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _handleLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(
              'Logout',
              style: AppTextStyles.buttonText.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      
      // Clear navigation history and go to onboarding
      Get.offAllNamed('/onboarding');
      
      // Reset navigation index
      navigationController.changePage(0);
      
      Get.snackbar(
        'Success',
        'You have been logged out successfully',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout. Please try again.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    ever(Get.routing.obs, (_) {
      navigationController.updateIndexBasedOnRoute(Get.currentRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
              vertical: AppDimensions.paddingS,
            ),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(_navItems.length, (index) {
                  final item = _navItems[index];
                  final isSelected = navigationController.currentIndex == index;

                  if (item.route == '/logout') {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 1,
                            color: AppColors.divider,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          _NavBarItem(
                            icon: isSelected ? item.selectedIcon : item.icon,
                            label: item.label,
                            isSelected: isSelected,
                            onTap: () => _onItemTapped(index),
                            isLogout: true,
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _NavBarItem(
                      icon: isSelected ? item.selectedIcon : item.icon,
                      label: item.label,
                      isSelected: isSelected,
                      onTap: () => _onItemTapped(index),
                      isLogout: false,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLogout;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLogout ? 12 : 8,
          vertical: 4,
        ),
        decoration: isLogout ? BoxDecoration(
          color: isSelected ? AppColors.error.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppAnimations.quick,
              curve: Curves.easeInOut,
              transform: Matrix4.identity()
                ..scale(isSelected ? 1.2 : 1.0),
              child: Icon(
                icon,
                color: isLogout 
                    ? (isSelected ? AppColors.error : AppColors.error.withOpacity(0.7))
                    : (isSelected ? AppColors.accent : AppColors.textLight),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isLogout 
                    ? (isSelected ? AppColors.error : AppColors.error.withOpacity(0.7))
                    : (isSelected ? AppColors.accent : AppColors.textLight),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}