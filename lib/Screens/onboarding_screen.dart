import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../controllers/onboarding_controller.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late final OnboardingController controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OnboardingController());
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String text,
    required bool isSecondary,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isSecondary)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.transparent : AppColors.primary,
          foregroundColor: isSecondary ? AppColors.primary : Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSecondary ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppTextStyles.buttonText.copyWith(
            color: isSecondary ? AppColors.primary : Colors.white,
            letterSpacing: 0.5,
          ),
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                // Gradient Background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.background,
                        AppColors.background.withOpacity(0.8),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
                
                // Page View with Physics
                PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  physics: const BouncingScrollPhysics(),
                  itemCount: OnboardingContent.pages.length,
                  itemBuilder: (context, index) => OnboardingPage(
                    content: OnboardingContent.pages[index],
                  ),
                ),

                // Bottom Navigation with Animations
                Positioned(
                  bottom: screenHeight * 0.02,
                  left: 20,
                  right: 20,
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Page Indicator
                        Obx(() => AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: 1.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              OnboardingContent.pages.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                height: 2,
                                width: controller.currentPage.value == index ? 24 : 12,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: controller.currentPage.value == index
                                      ? AppColors.primary
                                      : AppColors.secondary.withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                        )),

                        const SizedBox(height: 20),

                        // Navigation Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Skip Button
                            _buildButton(
                              onPressed: controller.skipToLogin,
                              text: 'Skip',
                              isSecondary: true,
                            ),

                            // Next/Login Button
                            Obx(() => _buildButton(
                              onPressed: controller.nextPage,
                              text: controller.currentPage.value == 2 ? 'Login' : 'Next',
                              isSecondary: false,
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}