import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/data_sources/auth_local_data_source.dart';
import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

import '../../features/products/data/data_sources/products_remote_data_source.dart';
import '../../features/products/data/repositories/products_repository_impl.dart';

import '../../features/cart/data/data_sources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';

import '../../features/wishlist/data/data_sources/wishlist_local_data_source.dart';
import '../../features/wishlist/data/repositories/wishlist_repository_impl.dart';

import '../../features/orders/data/data_sources/orders_local_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';

import '../network/dio_client.dart';
import '../network/network_info.dart';

class Injection {
  static Future<AppDependencies> initialize() async {
    // External
    final sharedPreferences =
    await SharedPreferences.getInstance();

    final dio = Dio();

    // Core
    final networkInfo = NetworkInfoImpl();
    final dioClient = DioClient(dio);

    // Data Sources
    final authRemoteDataSource =
    AuthRemoteDataSourceImpl(dioClient);

    final authLocalDataSource =
    AuthLocalDataSourceImpl(sharedPreferences);

    final productsRemoteDataSource =
    ProductsRemoteDataSourceImpl(dioClient);

    final cartLocalDataSource =
    CartLocalDataSourceImpl(sharedPreferences);

    final wishlistLocalDataSource =
    WishlistLocalDataSourceImpl(sharedPreferences);

    final ordersLocalDataSource =
    OrdersLocalDataSourceImpl(sharedPreferences);

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

    final cartRepository =
    CartRepositoryImpl(cartLocalDataSource);

    final wishlistRepository =
    WishlistRepositoryImpl(wishlistLocalDataSource);

    final ordersRepository =
    OrdersRepositoryImpl(ordersLocalDataSource);

    return AppDependencies(
      authRepository: authRepository,
      productsRepository: productsRepository,
      cartRepository: cartRepository,
      wishlistRepository: wishlistRepository,
      ordersRepository: ordersRepository,
      sharedPreferences: sharedPreferences,
    );
  }
}

class AppDependencies {
  final AuthRepositoryImpl authRepository;
  final ProductsRepositoryImpl productsRepository;
  final CartRepositoryImpl cartRepository;
  final WishlistRepositoryImpl wishlistRepository;
  final OrdersRepositoryImpl ordersRepository;
  final SharedPreferences sharedPreferences;

  const AppDependencies({
    required this.authRepository,
    required this.productsRepository,
    required this.cartRepository,
    required this.wishlistRepository,
    required this.ordersRepository,
    required this.sharedPreferences,
  });
}