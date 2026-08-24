import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(const FilterState());

  void setPriceRange(double min, double max) {
    emit(state.copyWith(minPrice: min, maxPrice: max));
  }

  void setSort(String? sortBy, String order) {
    emit(state.copyWith(sortBy: sortBy, order: order));
  }

  void resetFilters() {
    emit(const FilterState());
  }
}
