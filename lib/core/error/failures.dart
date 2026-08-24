import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server Failure']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache Failure']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No Internet Connection']) : super(message);
}
