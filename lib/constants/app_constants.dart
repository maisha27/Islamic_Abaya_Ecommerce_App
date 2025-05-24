import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Islamic-themed color palette
  static const Color primary = Color(0xFF1F4037);      // Deep Islamic Green
  static const Color secondary = Color(0xFF99B898);    // Soft Sage
  static const Color accent = Color(0xFFB4A06C);       // Islamic Gold
  static const Color background = Color(0xFFF8F3E6);   // Warm Parchment
  static const Color text = Color(0xFF2D3436);         // Deep Charcoal
  static const Color textLight = Color(0xFF636E72);    // Soft Gray
  
  // Button Colors
  static const Color buttonPrimary = Color(0xFF1F4037);
  static const Color buttonSecondary = Color(0xFFB4A06C);

  // Additional Colors for Home Screen
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color divider = Color(0xFFEEEEEE);

  // Gradients
  static final primaryGradient = LinearGradient(
    colors: [
      primary.withOpacity(0.8),
      primary,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTextStyles {
  // Using your Google Fonts
  static TextStyle headline = GoogleFonts.cairo(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    letterSpacing: 0.5,
  );
  
  static TextStyle subheadline = GoogleFonts.amiri(
    fontSize: 16,
    color: AppColors.textLight,
    letterSpacing: 0.3,
  );
  
  static TextStyle buttonText = GoogleFonts.tajawal(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Additional styles for home screen
  static TextStyle body = GoogleFonts.tajawal(
    fontSize: 14,
    color: AppColors.text,
    letterSpacing: 0.3,
  );

  static TextStyle caption = GoogleFonts.amiri(
    fontSize: 12,
    color: AppColors.textLight,
    letterSpacing: 0.2,
  );

  static TextStyle price = GoogleFonts.cairo(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );

  static TextStyle categoryTitle = GoogleFonts.tajawal(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    letterSpacing: 0.3,
  );

  static TextStyle productTitle = GoogleFonts.amiri(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
    letterSpacing: 0.3,
  );
}

class AppDimensions {
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 20.0;

  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 40.0;
}

class AppDecorations {
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration geometricPattern = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
    border: Border.all(
      color: AppColors.primary.withOpacity(0.2),
      width: 1,
    ),
    image: const DecorationImage(
      image: AssetImage('assets/images/patterns/geometric.png'),
      opacity: 0.1,
      fit: BoxFit.cover,
    ),
  );
}

class AppAnimations {
  static const Duration quick = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  static const Curve standard = Curves.easeInOut;
  static const Curve emphasized = Curves.easeOutBack;
}
class OnboardingContent {
  static final List<Map<String, dynamic>> pages = [
    {
      'title': 'Welcome to HayaLumière',
      'description': 'Explore a wide range of stylish, modest abayas, hijabs, and accessories that reflect elegance and faith.',
      'mainImage': 'assets/images/main.jpg',      // Large left image
      'topRightImage': 'assets/images/onboarding1_top.jpg',   // Top right image
      'bottomRightImage': 'assets/images/onboarding2_bottom.jpg', // Bottom right image
      'currentPage': 0,
    },
    {
      'title': 'Elegance Meets Modesty',
      'description': 'Discover high-quality, beautifully designed pieces that cater to your modest fashion needs.',
      'mainImage': 'assets/images/onboarding2_main.jpg',
      'topRightImage': 'assets/images/onboarding2_top.jpg',
      'bottomRightImage': 'assets/images/onboarding3_bottom.jpg',
      'currentPage': 1,
    },
    {
      'title': 'Latest Outfit & Easy Shopping Experience',
      'description': 'With secure payment options and fast delivery, your perfect abaya is just a few clicks away.',
      'mainImage': 'assets/images/main2.jpg',
      'topRightImage': 'assets/images/onboarding3_top.jpg',
      'bottomRightImage': 'assets/images/onboarding3_main.jpg',
      'currentPage': 2,
    },
  ];
}