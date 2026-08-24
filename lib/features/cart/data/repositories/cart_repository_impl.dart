import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/data/models/product_model.dart';
import '../../repository/cart_repository.dart';
import '../data_sources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<CartItemModel>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(ProductModel product) async {
    try {
      final items = await localDataSource.getCartItems();
      final index = items.indexWhere((item) => item.product.id == product.id);
      
      if (index >= 0) {
        items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
      } else {
        items.add(CartItemModel(product: product, quantity: 1));
      }
      
      await localDataSource.saveCartItems(items);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int productId) async {
    try {
      final items = await localDataSource.getCartItems();
      items.removeWhere((item) => item.product.id == productId);
      await localDataSource.saveCartItems(items);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(int productId, int quantity) async {
    try {
      final items = await localDataSource.getCartItems();
      final index = items.indexWhere((item) => item.product.id == productId);
      
      if (index >= 0) {
        if (quantity <= 0) {
          items.removeAt(index);
        } else {
          items[index] = items[index].copyWith(quantity: quantity);
        }
        await localDataSource.saveCartItems(items);
      }
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.saveCartItems([]);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
