import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/repository/auth_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository authRepository;

  ProfileCubit(this.authRepository) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    final result = await authRepository.getSavedUser();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) {
        if (user != null) {
          emit(ProfileLoaded(user));
        } else {
          emit(const ProfileError('User not found'));
        }
      },
    );
  }
}
