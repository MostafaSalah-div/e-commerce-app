import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/products_repository.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final ProductsRepository productsRepository;

  CategoryCubit(this.productsRepository) : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());
    final result = await productsRepository.getCategories();
    result.fold(
      (failure) => emit(CategoryError(failure.message)),
      (categories) => emit(CategoryLoaded(categories)),
    );
  }

  void selectCategory(String? category) {
    if (state is CategoryLoaded) {
      final currentState = state as CategoryLoaded;
      emit(CategoryLoaded(currentState.categories, selectedCategory: category));
    }
  }
}
