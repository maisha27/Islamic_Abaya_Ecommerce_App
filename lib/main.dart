import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'Screens/login_screen.dart';
import 'Screens/registration_screen.dart';
import 'Screens/home_screen.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize Get controllers
  Get.put(AuthController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      initialRoute: _initialRoute,
      getPages: [
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
      ],
      debugShowCheckedModeBanner: false,
    );
  }

  String get _initialRoute {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? '/home' : '/login';
  }
}

// Middleware to protect authenticated routes
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return FirebaseAuth.instance.currentUser == null
        ? const RouteSettings(name: '/login')
        : null;
  }
}

// Middleware to prevent authenticated users from accessing auth pages
class NoAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return FirebaseAuth.instance.currentUser != null
        ? const RouteSettings(name: '/home')
        : null;
  }
}