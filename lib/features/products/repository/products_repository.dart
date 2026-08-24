import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../data/models/product_model.dart';

abstract class ProductsRepository {
  Future<Either<Failure, ProductResponseModel>> getProducts({int limit = 20, int skip = 0});
  Future<Either<Failure, ProductResponseModel>> getProductsByCategory(String category, {int limit = 20, int skip = 0});
  Future<Either<Failure, ProductResponseModel>> searchProducts(String query, {int limit = 20, int skip = 0});
  Future<Either<Failure, List<String>>> getCategories();
}
