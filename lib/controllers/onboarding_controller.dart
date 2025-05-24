import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentPage = 0.obs;

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login page with animation
      Get.offNamed('/login');
    }
  }

  void skipToLogin() {
    // Navigate to login page with animation
    Get.offNamed('/login');
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}