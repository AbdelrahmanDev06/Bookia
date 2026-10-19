import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookia_app/featuers/auth/data/models/auth_models.dart';
import 'package:bookia_app/featuers/auth/data/repo/auth_repo.dart';
import 'package:bookia_app/featuers/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final res = await AuthRepo.login(
        LoginParams(email: email, password: password),
      );
      emit(AuthSuccess(res.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(AuthLoading());
    try {
      final res = await AuthRepo.register(
        RegisterParams(
          name: name,
          email: email,
          password: password,
          passwordConfirmation: confirmPassword,
        ),
      );
      emit(AuthSuccess(res.message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
