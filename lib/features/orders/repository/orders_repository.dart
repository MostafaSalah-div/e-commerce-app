import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../data/models/order_model.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders();
  Future<Either<Failure, void>> createOrder(OrderModel order);
}
