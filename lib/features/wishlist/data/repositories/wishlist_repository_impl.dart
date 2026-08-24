import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../products/data/models/product_model.dart';
import '../../repository/wishlist_repository.dart';
import '../data_sources/wishlist_local_data_source.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<ProductModel>>> getWishlistItems() async {
    try {
      final items = await localDataSource.getWishlist();
      return Right(items);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> toggleWishlist(ProductModel product) async {
    try {
      final items = await localDataSource.getWishlist();
      final index = items.indexWhere((item) => item.id == product.id);
      
      if (index >= 0) {
        items.removeAt(index);
      } else {
        items.add(product);
      }
      
      await localDataSource.saveWishlist(items);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isInWishlist(int productId) async {
    try {
      final items = await localDataSource.getWishlist();
      return Right(items.any((item) => item.id == productId));
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
