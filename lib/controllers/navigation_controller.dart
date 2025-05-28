import 'package:get/get.dart';

class NavigationController extends GetxController {
  final _currentIndex = 0.obs;
  
  int get currentIndex => _currentIndex.value;
  
  void changePage(int index) {
    _currentIndex.value = index;
  }
  
  void updateIndexBasedOnRoute(String route) {
    final navItems = [
      '/home',
      '/wishlist',
      '/cart',
      '/account',
      '/contact',
      '/logout', // Add logout route
    ];
    
    final index = navItems.indexOf(route);
    if (index != -1) {
      _currentIndex.value = index;
    }
  }

  // Reset navigation index
  void resetIndex() {
    _currentIndex.value = 0;
  }
}