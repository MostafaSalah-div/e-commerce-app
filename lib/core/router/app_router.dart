import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/onboarding/presentation/pages/splash_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/navigation/presentation/pages/main_page.dart';
import '../../features/products/presentation/pages/product_details_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/products/data/models/product_model.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/product-details',
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return ProductDetailsPage(product: product);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersPage(),
      ),
    ],
  );
}
