import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await dioClient.post(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.register,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );
      return UserModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
