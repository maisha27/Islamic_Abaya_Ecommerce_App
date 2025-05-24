import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_constants.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _selectedIndex = 0;

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
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Get.toNamed(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = _selectedIndex == index;

              return _NavBarItem(
                icon: isSelected ? item.selectedIcon : item.icon,
                label: item.label,
                isSelected: isSelected,
                onTap: () => _onItemTapped(index),
              );
            }),
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

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        ),
        child: AnimatedContainer(
          duration: AppAnimations.quick,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon with animation
              AnimatedContainer(
                duration: AppAnimations.quick,
                curve: Curves.easeInOut,
                transform: Matrix4.identity()
                  ..scale(isSelected ? 1.2 : 1.0),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.accent : AppColors.textLight,
                  size: AppDimensions.iconSizeM,
                ),
              ),
              const SizedBox(height: 4),
              // Label
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? AppColors.accent : AppColors.textLight,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}