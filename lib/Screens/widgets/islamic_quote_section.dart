import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class IslamicQuoteSection extends StatelessWidget {
  const IslamicQuoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingL,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Islamic Pattern Background
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  'assets/images/islamic_pattern_light.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Decorative Element
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.format_quote_rounded,
                    color: AppColors.accent,
                    size: AppDimensions.iconSizeXL,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.paddingM),

                // Quote Text
                Text(
                  '"Verily, with every hardship comes ease."',
                  style: AppTextStyles.headline.copyWith(
                    fontSize: 22,
                    color: AppColors.primary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimensions.paddingS),

                // Quote Source
                Text(
                  '- Surah Ash-Sharh, 94:6',
                  style: AppTextStyles.subheadline.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimensions.paddingL),

                // Daily Reflection
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Daily Reflection',
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingS),
                      Text(
                        'Let our modest fashion choices reflect the beauty of patience and perseverance in our journey.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textLight,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.paddingM),

                // Current Date
                Text(
                  'Today: May 24, 2025',  // Using the date from your context
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}