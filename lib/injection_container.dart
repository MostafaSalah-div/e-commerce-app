import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/data/data_sources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/products/data/data_sources/products_remote_data_source.dart';
import 'features/products/data/repositories/products_repository_impl.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/cubit/category_cubit.dart';
import 'features/products/presentation/cubit/search_cubit.dart';
import 'features/products/presentation/cubit/filter_cubit.dart';
import 'features/cart/data/data_sources/cart_local_data_source.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/wishlist/data/data_sources/wishlist_local_data_source.dart';
import 'features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'features/orders/data/data_sources/orders_local_data_source.dart';
import 'features/orders/data/repositories/orders_repository_impl.dart';
import 'features/orders/presentation/cubit/orders_cubit.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/checkout/presentation/cubit/checkout_cubit.dart';
import 'features/auth/repository/auth_repository.dart';
import 'features/products/repository/products_repository.dart';
import 'features/cart/repository/cart_repository.dart';
import 'features/wishlist/repository/wishlist_repository.dart';
import 'features/orders/repository/orders_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // BLoC / Cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => ProductsBloc(sl()));
  sl.registerFactory(() => CategoryCubit(sl()));
  sl.registerFactory(() => SearchCubit(sl()));
  sl.registerFactory(() => FilterCubit());
  sl.registerFactory(() => CartCubit(sl()));
  sl.registerFactory(() => WishlistCubit(sl()));
  sl.registerFactory(() => OrdersCubit(sl()));
  sl.registerFactory(() => ProfileCubit(sl()));
  sl.registerFactory(() => CheckoutCubit());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<WishlistLocalDataSource>(
    () => WishlistLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<OrdersLocalDataSource>(
    () => OrdersLocalDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  sl.registerLazySingleton(() => DioClient(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
}
