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
    if (result != null) {
      emit(ProfileSuccessState(result));
    } else if (profile == null) {
      emit(ProfileErrorState());
    }
  }

  Future<bool> updateProfile({
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
    if (result == null) return false;
    emit(ProfileSuccessState(result));
    return true;
  }

  Future<void> logout() async {
    await ProfileRepo.logout();
    emit(ProfileInitial());
  }
}
