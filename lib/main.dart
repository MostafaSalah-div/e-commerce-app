import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/cubit/category_cubit.dart';
import 'features/products/presentation/cubit/search_cubit.dart';
import 'features/products/presentation/cubit/filter_cubit.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'features/orders/presentation/cubit/orders_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/checkout/presentation/cubit/checkout_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthCubit>()..checkAuthStatus()),
        BlocProvider(create: (_) => di.sl<ProductsBloc>()),
        BlocProvider(create: (_) => di.sl<CategoryCubit>()..getCategories()),
        BlocProvider(create: (_) => di.sl<SearchCubit>()),
        BlocProvider(create: (_) => di.sl<FilterCubit>()),
        BlocProvider(create: (_) => di.sl<CartCubit>()..getCart()),
        BlocProvider(create: (_) => di.sl<WishlistCubit>()..getWishlist()),
        BlocProvider(create: (_) => di.sl<OrdersCubit>()..getOrders()),
        BlocProvider(create: (_) => di.sl<ProfileCubit>()),
        BlocProvider(create: (_) => di.sl<CheckoutCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Ecommerce App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
