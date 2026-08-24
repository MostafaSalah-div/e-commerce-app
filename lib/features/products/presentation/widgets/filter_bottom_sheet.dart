import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/filter_cubit.dart';
import '../cubit/filter_state.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter & Sort',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text('Sort By', style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButton<String>(
                isExpanded: true,
                value: state.sortBy,
                hint: const Text('Select Sort'),
                items: const [
                  DropdownMenuItem(value: 'price', child: Text('Price')),
                  DropdownMenuItem(value: 'rating', child: Text('Rating')),
                  DropdownMenuItem(value: 'title', child: Text('Title')),
                ],
                onChanged: (val) => context.read<FilterCubit>().setSort(val, state.order),
              ),
              const SizedBox(height: 10),
              const Text('Order', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Asc'),
                      value: 'asc',
                      groupValue: state.order,
                      onChanged: (val) => context.read<FilterCubit>().setSort(state.sortBy, val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Desc'),
                      value: 'desc',
                      groupValue: state.order,
                      onChanged: (val) => context.read<FilterCubit>().setSort(state.sortBy, val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // In a real app, we'd apply this to the ProductsBloc
                  // DummyJSON doesn't support complex server-side filtering 
                  // but we can trigger a reload with sort params if it did.
                  context.read<ProductsBloc>().add(const LoadProducts(refresh: true));
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
              TextButton(
                onPressed: () {
                  context.read<FilterCubit>().resetFilters();
                  Navigator.pop(context);
                },
                child: const Center(child: Text('Reset')),
              ),
            ],
          ),
        );
      },
    );
  }
}
