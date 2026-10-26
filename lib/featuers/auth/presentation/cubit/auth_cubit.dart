import 'package:bloc/bloc.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/featuers/auth/data/repo/auth_repo.dart';
import 'package:meta/meta.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  login({required String email, required String password}) async {
    emit(LoadLoadingState());
    final response = await AuthRepo.login(email: email, password: password);

    final token = response?.token;
    if (token != null && token.isNotEmpty) {
      await LocalHelper.saveToken(token);
      emit(LoginSuccessState());
    } else {
      emit(LoginErrorState());
    }
  }

  register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(LoadLoadingState());
    final response = await AuthRepo.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (response != null) {
      emit(RegisterSuccessState());
    } else {
      emit(RegisterErrorState());
    }
  }
}
