import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/product_model.dart';

abstract class ProductsRemoteDataSource {
  Future<ProductResponseModel> getProducts({int limit = 20, int skip = 0});
  Future<ProductResponseModel> getProductsByCategory(String category, {int limit = 20, int skip = 0});
  Future<ProductResponseModel> searchProducts(String query, {int limit = 20, int skip = 0});
  Future<List<String>> getCategories();
}

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  final DioClient dioClient;

  ProductsRemoteDataSourceImpl(this.dioClient);

  @override
  Future<ProductResponseModel> getProducts({int limit = 20, int skip = 0}) async {
    final response = await dioClient.get(
      ApiConstants.products,
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> getProductsByCategory(String category, {int limit = 20, int skip = 0}) async {
    final response = await dioClient.get(
      ApiConstants.productsByCategory(category),
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<ProductResponseModel> searchProducts(String query, {int limit = 20, int skip = 0}) async {
    final response = await dioClient.get(
      ApiConstants.search,
      queryParameters: {'q': query, 'limit': limit, 'skip': skip},
    );
    return ProductResponseModel.fromJson(response.data);
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await dioClient.get(ApiConstants.categories);
    // DummyJSON categories can be a list of strings or list of objects depending on version
    // Modern DummyJSON returns list of objects with slug and name
    if (response.data is List) {
      if (response.data.isNotEmpty && response.data[0] is Map) {
        return (response.data as List).map((e) => e['slug'] as String).toList();
      }
      return List<String>.from(response.data);
    }
    return [];
  }
}
