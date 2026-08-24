import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../repository/auth_repository.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    // 1. Local Check First
    final accounts = await localDataSource.getRegisteredAccounts();
    try {
      final localUser = accounts.firstWhere(
              (u) => u.email.toLowerCase() == email.toLowerCase() && u.password == password
      );
      await localDataSource.saveUser(localUser);
      return Right(localUser);
    } catch (_) {}

    // 2. Remote Fallback (Uses username if email looks like a DummyJSON username)
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.login(email, password);
        await localDataSource.saveUser(remoteUser);
        return Right(remoteUser);
      } on DioException catch (e) {
        return Left(ServerFailure(e.response?.data['message'] ?? 'Invalid credentials'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    }
    return const Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, UserModel>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    // Check if email exists locally
    final accounts = await localDataSource.getRegisteredAccounts();
    if (accounts.any((a) => a.email.toLowerCase() == email.toLowerCase())) {
      return const Left(ServerFailure('Email already registered'));
    }

    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.register(
          firstName: firstName, lastName: lastName, email: email, password: password,
        );

        final userToSave = UserModel(
          id: remoteUser.id,
          username: email.split('@')[0],
          email: email,
          firstName: firstName,
          lastName: lastName,
          gender: remoteUser.gender,
          image: remoteUser.image,
          token: remoteUser.token,
          password: password,
        );

        await localDataSource.persistAccount(userToSave);
        await localDataSource.saveUser(userToSave);
        return Right(userToSave);
      } on DioException catch (e) {
        return Left(ServerFailure(e.response?.data['message'] ?? 'Registration failed'));
      }
    }
    return const Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await localDataSource.clearUser();
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserModel?>> getSavedUser() async {
    final user = await localDataSource.getUser();
    return Right(user);
  }

  @override
  Future<bool> isLoggedIn() async => await localDataSource.getUser() != null;
}