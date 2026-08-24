import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final double? minPrice;
  final double? maxPrice;
  final String? sortBy;
  final String order; // 'asc' or 'desc'

  const FilterState({
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.order = 'asc',
  });

  FilterState copyWith({
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) {
    return FilterState(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [minPrice, maxPrice, sortBy, order];
}
