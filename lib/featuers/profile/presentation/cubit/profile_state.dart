part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileSuccessState extends ProfileState {
  final ProfileModel profile;

  ProfileSuccessState(this.profile);
}

final class ProfileErrorState extends ProfileState {}
