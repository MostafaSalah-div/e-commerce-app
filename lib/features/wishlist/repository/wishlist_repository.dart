import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../products/data/models/product_model.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<ProductModel>>> getWishlistItems();
  Future<Either<Failure, void>> toggleWishlist(ProductModel product);
  Future<Either<Failure, bool>> isInWishlist(int productId);
}
