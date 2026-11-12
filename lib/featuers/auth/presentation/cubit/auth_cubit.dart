import 'package:bloc/bloc.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/featuers/auth/data/repo/auth_repo.dart';
import 'package:meta/meta.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoadLoadingState());
    final result = await AuthRepo.login(email: email, password: password);

    await result.fold(
      (failure) async => emit(LoginErrorState(failure.message)),
      (response) async {
        await LocalHelper.saveToken(response.token!);
        emit(LoginSuccessState());
      },
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(LoadLoadingState());
    final result = await AuthRepo.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    await result.fold(
      (failure) async => emit(RegisterErrorState(failure.message)),
      (response) async {
        final token = response.token;
        if (token != null && token.isNotEmpty) {
          await LocalHelper.saveToken(token);
        }
        emit(RegisterSuccessState(response.message ?? 'Account created'));
      },
    );
  }

  Future<void> forgetPassword(String email) async {
    emit(LoadLoadingState());
    final result = await AuthRepo.forgetPassword(email);

    result.fold(
      (failure) => emit(ForgetPasswordErrorState(failure.message)),
      (message) => emit(ForgetPasswordSuccessState(message)),
    );
  }
}
