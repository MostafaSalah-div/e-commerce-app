import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login(String email, String password);
  Future<Either<Failure, UserModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserModel?>> getSavedUser();
  Future<bool> isLoggedIn();
}
