import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/orders_repository.dart';
import '../../../orders/data/models/order_model.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository ordersRepository;

  OrdersCubit(this.ordersRepository) : super(OrdersInitial());

  Future<void> getOrders() async {
    emit(OrdersLoading());
    final result = await ordersRepository.getOrders();
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> createOrder(OrderModel order) async {
    final result = await ordersRepository.createOrder(order);
    result.fold(
      (failure) => emit(OrdersError(failure.message)),
      (_) => getOrders(),
    );
  }
}
