import 'package:bloc/bloc.dart';
import 'package:bookia_app/featuers/profile/data/models/profile_model.dart';
import 'package:bookia_app/featuers/profile/data/repo/profile_repo.dart';
import 'package:meta/meta.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  ProfileModel? get profile {
    final current = state;
    return current is ProfileSuccessState ? current.profile : null;
  }

  Future<void> getProfile() async {
    if (profile == null) emit(ProfileLoadingState());

    final result = await ProfileRepo.getProfile();
    result.fold(
      (failure) {
        if (profile == null) emit(ProfileErrorState(failure.message));
      },
      (data) => emit(ProfileSuccessState(data)),
    );
  }

  /// returns `null` on success, or the error message
  Future<String?> updateProfile({
    required String name,
    required String phone,
    required String city,
    required String address,
  }) async {
    final result = await ProfileRepo.updateProfile(
      name: name,
      phone: phone,
      city: city,
      address: address,
    );
    return result.fold<String?>((failure) => failure.message, (data) {
      emit(ProfileSuccessState(data));
      return null;
    });
  }

  Future<void> logout() async {
    await ProfileRepo.logout();
    emit(ProfileInitial());
  }
}
