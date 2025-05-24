import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';


class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Us Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Text(
                  'About HayaLumière',
                  style: AppTextStyles.headline.copyWith(
                    color: AppColors.primary,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.paddingL),

          // Mission Statement
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              'HayaLumière is dedicated to providing elegant, modest fashion that embraces both traditional values and contemporary style. Our carefully curated collection reflects the grace and dignity of Islamic wear while meeting the needs of the modern Muslim woman.',
              style: AppTextStyles.body.copyWith(
                height: 1.6,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppDimensions.paddingXL),

          // Islamic Pattern Divider
          Center(
            child: Image.asset(
              'assets/images/divider.jpg', // Updated path to match your assets
              height: 12,
              width: 300,
              color: AppColors.accent.withOpacity(0.3),
            ),
          ),

          const SizedBox(height: AppDimensions.paddingL),

          // Store Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                value: '5000+',
                label: 'Products',
                icon: Icons.checkroom_outlined,
              ),
              _StatItem(
                value: '50+',
                label: 'Countries',
                icon: Icons.public_outlined,
              ),
              _StatItem(
                value: '10k+',
                label: 'Customers',
                icon: Icons.people_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: AppDimensions.iconSizeL,
          color: AppColors.accent,
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Text(
          value,
          style: AppTextStyles.headline.copyWith(
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }
}