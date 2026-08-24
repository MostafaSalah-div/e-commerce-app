import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepository.login(email, password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    final result = await authRepository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> checkAuthStatus() async {
    final userResult = await authRepository.getSavedUser();
    userResult.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> logout() async {
    await authRepository.logout();
    emit(Unauthenticated());
  }
}
