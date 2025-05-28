import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:islamic_store/Screens/orders_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_store/Screens/cart_screen.dart';
import 'package:islamic_store/Screens/checkout_page.dart';
import 'package:islamic_store/Screens/onboarding_screen.dart';
import 'package:islamic_store/Screens/wishlist_page.dart';
import 'package:islamic_store/constants/app_constants.dart';
import 'package:islamic_store/controllers/cart_controller.dart';
import 'package:islamic_store/controllers/checkout_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'Screens/product_details_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/registration_screen.dart';
import 'Screens/home_screen.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Check if first time
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  final user = FirebaseAuth.instance.currentUser;
  
  // Initialize Get controllers
  Get.put(AuthController());
  Get.put(WishlistController(), permanent: true);

  // Record app launch
  await prefs.setString('lastLaunch', '2025-05-26 06:49:01');
  
  runApp(MyApp(
    hasSeenOnboarding: hasSeenOnboarding,
    isLoggedIn: user != null,
  ));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;
  final bool isLoggedIn;
  
  const MyApp({
    super.key,
    required this.hasSeenOnboarding,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HayaLumière',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      initialRoute: _getInitialRoute(),
      getPages: [
        GetPage(
          name: '/onboarding',
          page: () => const OnboardingScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          middlewares: [NoAuthMiddleware()],
        ),
        GetPage(
          name: '/register',
          page: () => const RegistrationScreen(),
          middlewares: [NoAuthMiddleware()],
        ),
        GetPage(
          name: '/home',
          page: () => HomeScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/wishlist',
          page: () => const WishlistPage(),
          binding: BindingsBuilder(() {
            if (!Get.isRegistered<WishlistController>()) {
              Get.put(WishlistController());
            }
          }),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/product-details/:id',
          page: () {
            final arguments = Get.arguments;
            if (arguments == null || !(arguments is Map) || !arguments.containsKey('product')) {
              return Scaffold(
                body: Center(
                  child: Text(
                    'Product not found',
                    style: AppTextStyles.headline.copyWith(color: AppColors.error),
                  ),
                ),
              );
            }
            return ProductDetailsScreen(product: arguments['product']);
          },
        ),
        GetPage(
          name: '/cart',
          page: () => CartScreen(),
          binding: BindingsBuilder(() {
            Get.put(CartController());
          }),
        ),
        GetPage(
          name: '/checkout',
          page: () => const CheckoutPage(),
          binding: BindingsBuilder(() {
            if (!Get.isRegistered<CartController>()) {
              Get.put(CartController());
            }
            Get.put(CheckoutController());
          }),
          middlewares: [
            AuthMiddleware(),
            CartMiddleware(),
          ],
        ),
        GetPage(name: '/orders', page: () => const OrdersPage()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }

  String _getInitialRoute() {
    if (!hasSeenOnboarding) {
      return '/onboarding';
    }
    return isLoggedIn ? '/home' : '/login';
  }
}

// Middleware classes
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return FirebaseAuth.instance.currentUser == null
        ? const RouteSettings(name: '/login')
        : null;
  }
}

class NoAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == '/onboarding') return null;
    
    return FirebaseAuth.instance.currentUser != null
        ? const RouteSettings(name: '/home')
        : null;
  }
}

// CartMiddleware remains the same
class CartMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == '/checkout') {
      final cartController = Get.find<CartController>();
      if (cartController.cartItems.isEmpty) {
        return const RouteSettings(name: '/cart');
      }
    }
    return null;
  }
}

// WishlistMiddleware remains the same
class WishlistMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (route == '/wishlist') {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar(
          'Authentication Required',
          'Please login to access your wishlist',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return const RouteSettings(name: '/login');
      }
    }
    return null;
  }
}