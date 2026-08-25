import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/repository/auth_repository.dart';

import 'features/products/data/data_sources/products_remote_data_source.dart';
import 'features/products/data/repositories/products_repository_impl.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/cubit/category_cubit.dart';
import 'features/products/presentation/cubit/search_cubit.dart';
import 'features/products/presentation/cubit/filter_cubit.dart';
import 'features/products/repository/products_repository.dart';

import 'features/cart/data/data_sources/cart_local_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/cart/repository/cart_repository.dart';

import 'features/wishlist/data/data_sources/wishlist_local_data_source.dart';
import 'features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'features/wishlist/repository/wishlist_repository.dart';

import 'features/orders/data/data_sources/orders_local_data_source.dart';
import 'features/orders/data/repositories/orders_repository_impl.dart';
import 'features/orders/presentation/cubit/orders_cubit.dart';
import 'features/orders/repository/orders_repository.dart';

import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/checkout/presentation/cubit/checkout_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  final dio = Dio();

  // Core
  final networkInfo = NetworkInfoImpl();
  final dioClient = DioClient(dio);

  // Data Sources
  final authRemoteDataSource = AuthRemoteDataSourceImpl(dioClient);
  final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences);
  final productsRemoteDataSource = ProductsRemoteDataSourceImpl(dioClient);
  final cartLocalDataSource = CartLocalDataSourceImpl(sharedPreferences);
  final wishlistLocalDataSource = WishlistLocalDataSourceImpl(sharedPreferences);
  final ordersLocalDataSource = OrdersLocalDataSourceImpl(sharedPreferences);

  // Repositories
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
    networkInfo: networkInfo,
  );
  final productsRepository = ProductsRepositoryImpl(
    remoteDataSource: productsRemoteDataSource,
    networkInfo: networkInfo,
  );
  final cartRepository = CartRepositoryImpl(cartLocalDataSource);
  final wishlistRepository = WishlistRepositoryImpl(wishlistLocalDataSource);
  final ordersRepository = OrdersRepositoryImpl(ordersLocalDataSource);

  runApp(MyApp(
    authRepository: authRepository,
    productsRepository: productsRepository,
    cartRepository: cartRepository,
    wishlistRepository: wishlistRepository,
    ordersRepository: ordersRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final ProductsRepository productsRepository;
  final CartRepository cartRepository;
  final WishlistRepository wishlistRepository;
  final OrdersRepository ordersRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.productsRepository,
    required this.cartRepository,
    required this.wishlistRepository,
    required this.ordersRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(authRepository)..checkAuthStatus()),
        BlocProvider(create: (_) => ProductsBloc(productsRepository)),
        BlocProvider(create: (_) => CategoryCubit(productsRepository)..getCategories()),
        BlocProvider(create: (_) => SearchCubit(productsRepository)),
        BlocProvider(create: (_) => FilterCubit()),
        BlocProvider(create: (_) => CartCubit(cartRepository)..getCart()),
        BlocProvider(create: (_) => WishlistCubit(wishlistRepository)..getWishlist()),
        BlocProvider(create: (_) => OrdersCubit(ordersRepository)..getOrders()),
        BlocProvider(create: (_) => ProfileCubit(authRepository)),
        BlocProvider(create: (_) => CheckoutCubit()),
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
