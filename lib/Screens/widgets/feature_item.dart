import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class FeaturesGrid extends StatelessWidget {
  const FeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Why Choose Us',
            style: AppTextStyles.headline.copyWith(
              fontSize: 24,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: AppDimensions.paddingM,
            crossAxisSpacing: AppDimensions.paddingM,
            childAspectRatio: 1.2,
            children: const [
              _FeatureItem(
                icon: Icons.local_shipping_outlined,
                title: 'Fast Shipping',
                description: 'Quick delivery worldwide',
              ),
              _FeatureItem(
                icon: Icons.verified_outlined,
                title: 'Islamic Values',
                description: 'Adhering to modest fashion',
              ),
              _FeatureItem(
                icon: Icons.design_services_outlined,
                title: 'Unique Designs',
                description: 'Exclusive collections',
              ),
              _FeatureItem(
                icon: Icons.support_outlined,
                title: '24/7 Support',
                description: 'Always here to help',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: AppColors.accent,
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            title,
            style: AppTextStyles.buttonText.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}