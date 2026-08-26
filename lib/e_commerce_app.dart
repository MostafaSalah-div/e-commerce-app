import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/repository/auth_repository.dart';
import 'features/cart/repository/cart_repository.dart';
import 'features/orders/repository/orders_repository.dart';
import 'features/products/repository/products_repository.dart';
import 'features/profile/presentation/cubit/settings_cubit.dart';
import 'features/profile/presentation/cubit/settings_state.dart';
import 'features/wishlist/repository/wishlist_repository.dart';

class ECommerceApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ProductsRepository productsRepository;
  final CartRepository cartRepository;
  final WishlistRepository wishlistRepository;
  final OrdersRepository ordersRepository;
  final SharedPreferences sharedPreferences;

  const ECommerceApp({
    super.key,
    required this.authRepository,
    required this.productsRepository,
    required this.cartRepository,
    required this.wishlistRepository,
    required this.ordersRepository,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppProviders.providers(
        authRepository: authRepository,
        productsRepository: productsRepository,
        cartRepository: cartRepository,
        wishlistRepository: wishlistRepository,
        ordersRepository: ordersRepository,
        sharedPreferences: sharedPreferences,
      ),
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Ecommerce App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.themeMode,
          locale: state.locale,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}