import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<ProductModel> products;
  final String? errorMessage;
  final bool hasReachedMax;
  final String? selectedCategory;
  final String? searchQuery;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.errorMessage,
    this.hasReachedMax = false,
    this.selectedCategory,
    this.searchQuery,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    bool? hasReachedMax,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        errorMessage,
        hasReachedMax,
        selectedCategory,
        searchQuery,
      ];
}
