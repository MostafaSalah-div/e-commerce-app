import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/repository/auth_repository.dart';

import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/repository/cart_repository.dart';

import '../../features/checkout/presentation/cubit/checkout_cubit.dart';

import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/orders/repository/orders_repository.dart';

import '../../features/products/presentation/bloc/products_bloc.dart';
import '../../features/products/presentation/cubit/category_cubit.dart';
import '../../features/products/presentation/cubit/filter_cubit.dart';
import '../../features/products/presentation/cubit/search_cubit.dart';
import '../../features/products/repository/products_repository.dart';

import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/cubit/settings_cubit.dart';

import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../features/wishlist/repository/wishlist_repository.dart';

class AppProviders {
  static List<SingleChildWidget> providers({
    required AuthRepository authRepository,
    required ProductsRepository productsRepository,
    required CartRepository cartRepository,
    required WishlistRepository wishlistRepository,
    required OrdersRepository ordersRepository,
    required SharedPreferences sharedPreferences,
  }) {
    return [
      BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(authRepository)
          ..checkAuthStatus(),
      ),

      BlocProvider<ProductsBloc>(
        create: (_) => ProductsBloc(productsRepository),
      ),

      BlocProvider<CategoryCubit>(
        create: (_) => CategoryCubit(productsRepository)
          ..getCategories(),
      ),

      BlocProvider<SearchCubit>(
        create: (_) => SearchCubit(productsRepository),
      ),

      BlocProvider<FilterCubit>(
        create: (_) => FilterCubit(),
      ),

      BlocProvider<CartCubit>(
        create: (_) => CartCubit(cartRepository)
          ..getCart(),
      ),

      BlocProvider<WishlistCubit>(
        create: (_) => WishlistCubit(wishlistRepository)
          ..getWishlist(),
      ),

      BlocProvider<OrdersCubit>(
        create: (_) => OrdersCubit(ordersRepository)
          ..getOrders(),
      ),

      BlocProvider<ProfileCubit>(
        create: (_) => ProfileCubit(authRepository),
      ),

      BlocProvider<CheckoutCubit>(
        create: (_) => CheckoutCubit(),
      ),

      BlocProvider<SettingsCubit>(
        create: (_) => SettingsCubit(sharedPreferences),
      ),
    ];
  }
}