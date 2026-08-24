import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../repository/products_repository.dart';
import '../data_sources/products_remote_data_source.dart';
import '../models/product_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductResponseModel>> getProducts({int limit = 20, int skip = 0}) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts(limit: limit, skip: skip);
        return Right(products);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ProductResponseModel>> getProductsByCategory(String category, {int limit = 20, int skip = 0}) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProductsByCategory(category, limit: limit, skip: skip);
        return Right(products);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, ProductResponseModel>> searchProducts(String query, {int limit = 20, int skip = 0}) async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.searchProducts(query, limit: limit, skip: skip);
        return Right(products);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        return Right(categories);
      } catch (e) {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
