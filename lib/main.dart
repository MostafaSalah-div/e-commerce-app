import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'e_commerce_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await Injection.initialize();

  runApp(
    ECommerceApp(
      authRepository: dependencies.authRepository,
      productsRepository: dependencies.productsRepository,
      cartRepository: dependencies.cartRepository,
      wishlistRepository: dependencies.wishlistRepository,
      ordersRepository: dependencies.ordersRepository,
      sharedPreferences: dependencies.sharedPreferences,
    ),
  );
}