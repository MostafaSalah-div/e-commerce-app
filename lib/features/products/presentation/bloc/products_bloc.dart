import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/products_repository.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository productsRepository;

  ProductsBloc(this.productsRepository) : super(const ProductsState()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(status: ProductsStatus.loading, selectedCategory: null, searchQuery: null));
    
    final result = await productsRepository.getProducts(limit: 20, skip: 0);
    
    result.fold(
      (failure) => emit(state.copyWith(status: ProductsStatus.failure, errorMessage: failure.message)),
      (response) => emit(state.copyWith(
        status: ProductsStatus.success,
        products: response.products,
        hasReachedMax: response.products.length >= response.total,
      )),
    );
  }

  Future<void> _onLoadProductsByCategory(LoadProductsByCategory event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(status: ProductsStatus.loading, selectedCategory: event.category, searchQuery: null));
    
    final result = await productsRepository.getProductsByCategory(event.category, limit: 20, skip: 0);
    
    result.fold(
      (failure) => emit(state.copyWith(status: ProductsStatus.failure, errorMessage: failure.message)),
      (response) => emit(state.copyWith(
        status: ProductsStatus.success,
        products: response.products,
        hasReachedMax: response.products.length >= response.total,
      )),
    );
  }

  Future<void> _onLoadMoreProducts(LoadMoreProducts event, Emitter<ProductsState> emit) async {
    if (state.hasReachedMax || state.status == ProductsStatus.loading) return;

    final skip = state.products.length;
    final result = state.selectedCategory != null
        ? await productsRepository.getProductsByCategory(state.selectedCategory!, limit: 20, skip: skip)
        : state.searchQuery != null
            ? await productsRepository.searchProducts(state.searchQuery!, limit: 20, skip: skip)
            : await productsRepository.getProducts(limit: 20, skip: skip);

    result.fold(
      (failure) => emit(state.copyWith(status: ProductsStatus.failure, errorMessage: failure.message)),
      (response) => emit(state.copyWith(
        status: ProductsStatus.success,
        products: List.of(state.products)..addAll(response.products),
        hasReachedMax: (state.products.length + response.products.length) >= response.total,
      )),
    );
  }

  Future<void> _onSearchProducts(SearchProductsEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(status: ProductsStatus.loading, searchQuery: event.query, selectedCategory: null));
    
    final result = await productsRepository.searchProducts(event.query, limit: 20, skip: 0);
    
    result.fold(
      (failure) => emit(state.copyWith(status: ProductsStatus.failure, errorMessage: failure.message)),
      (response) => emit(state.copyWith(
        status: ProductsStatus.success,
        products: response.products,
        hasReachedMax: response.products.length >= response.total,
      )),
    );
  }
}
