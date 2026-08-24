import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../repository/orders_repository.dart';
import '../data_sources/orders_local_data_source.dart';
import '../models/order_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersLocalDataSource localDataSource;

  OrdersRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<OrderModel>>> getOrders() async {
    try {
      final orders = await localDataSource.getOrders();
      return Right(orders);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> createOrder(OrderModel order) async {
    try {
      await localDataSource.saveOrder(order);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
