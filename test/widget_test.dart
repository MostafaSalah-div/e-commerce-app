import 'package:dartz/dartz.dart';
import 'package:ecommerceapp/core/error/failures.dart';
import 'package:ecommerceapp/e_commerce_app.dart';
import 'package:ecommerceapp/features/auth/data/models/user_model.dart';
import 'package:ecommerceapp/features/auth/repository/auth_repository.dart';
import 'package:ecommerceapp/features/cart/data/models/cart_item_model.dart';
import 'package:ecommerceapp/features/cart/repository/cart_repository.dart';
import 'package:ecommerceapp/features/orders/data/models/order_model.dart';
import 'package:ecommerceapp/features/orders/repository/orders_repository.dart';
import 'package:ecommerceapp/features/products/data/models/product_model.dart';
import 'package:ecommerceapp/features/products/repository/products_repository.dart';
import 'package:ecommerceapp/features/wishlist/repository/wishlist_repository.dart';
import 'package:ecommerceapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock implementations for the required repositories
class MockAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async =>
      const Left(ServerFailure());
  @override
  Future<Either<Failure, UserModel>> register(
          {required String firstName,
          required String lastName,
          required String email,
          required String password}) async =>
      const Left(ServerFailure());
  @override
  Future<Either<Failure, void>> logout() async => const Right(null);
  @override
  Future<Either<Failure, UserModel?>> getSavedUser() async => const Right(null);
  @override
  Future<bool> isLoggedIn() async => false;
}

class MockProductsRepository implements ProductsRepository {
  @override
  Future<Either<Failure, ProductResponseModel>> getProducts(
          {int limit = 20, int skip = 0}) async =>
      const Right(ProductResponseModel(products: [], total: 0, skip: 0, limit: 20));
  @override
  Future<Either<Failure, ProductResponseModel>> getProductsByCategory(
          String category,
          {int limit = 20, int skip = 0}) async =>
      const Right(ProductResponseModel(products: [], total: 0, skip: 0, limit: 20));
  @override
  Future<Either<Failure, ProductResponseModel>> searchProducts(String query,
          {int limit = 20, int skip = 0}) async =>
      const Right(ProductResponseModel(products: [], total: 0, skip: 0, limit: 20));
  @override
  Future<Either<Failure, List<String>>> getCategories() async => const Right([]);
}

class MockCartRepository implements CartRepository {
  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItems() async => const Right([]);
  @override
  Future<Either<Failure, void>> addToCart(ProductModel product) async => const Right(null);
  @override
  Future<Either<Failure, void>> removeFromCart(int productId) async => const Right(null);
  @override
  Future<Either<Failure, void>> updateQuantity(int productId, int quantity) async => const Right(null);
  @override
  Future<Either<Failure, void>> clearCart() async => const Right(null);
}

class MockWishlistRepository implements WishlistRepository {
  @override
  Future<Either<Failure, List<ProductModel>>> getWishlistItems() async => const Right([]);
  @override
  Future<Either<Failure, void>> toggleWishlist(ProductModel product) async => const Right(null);
  @override
  Future<Either<Failure, bool>> isInWishlist(int productId) async => const Right(false);
}

class MockOrdersRepository implements OrdersRepository {
  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() async => const Right([]);
  @override
  Future<Either<Failure, void>> createOrder(OrderModel order) async => const Right(null);
}

void main() {
  testWidgets('App smoke test - verifies splash screen loads', (WidgetTester tester) async {
    // Setup Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    // Create repository instances
    final authRepository = MockAuthRepository();
    final productsRepository = MockProductsRepository();
    final cartRepository = MockCartRepository();
    final wishlistRepository = MockWishlistRepository();
    final ordersRepository = MockOrdersRepository();

    // Build our app and trigger a frame.
    // Fixed: Removed 'const' and passed all required dependencies.
    await tester.pumpWidget(ECommerceApp(
      authRepository: authRepository,
      productsRepository: productsRepository,
      cartRepository: cartRepository,
      wishlistRepository: wishlistRepository,
      ordersRepository: ordersRepository,
      sharedPreferences: sharedPreferences,
    ));

    // Verify that the Splash Screen elements are present.
    expect(find.text('MyShop'), findsOneWidget);
  });
}
