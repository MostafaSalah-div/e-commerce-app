import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/products_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final ProductsRepository productsRepository;

  SearchCubit(this.productsRepository) : super(SearchInitial());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    
    emit(SearchLoading());
    final result = await productsRepository.searchProducts(query);
    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (response) => emit(SearchLoaded(response.products)),
    );
  }
}
