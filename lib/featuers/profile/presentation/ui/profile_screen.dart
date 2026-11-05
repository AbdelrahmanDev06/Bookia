import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/cart/presentation/cubit/cart_cubit.dart';
import 'package:bookia_app/featuers/profile/presentation/cubit/profile_cubit.dart';
import 'package:bookia_app/featuers/profile/presentation/ui/widgets/profile_avatar.dart';
import 'package:bookia_app/featuers/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.darkgreyColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.mainColor),
            ),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;

    final navigator = Navigator.of(context);
    context.read<WishlistCubit>().clear();
    context.read<CartCubit>().clear();
    await context.read<ProfileCubit>().logout();
    navigator.pushNamedAndRemoveUntil(AppRoutes.WelcomeScreen, (_) => false);
  }

  void _comingSoon(BuildContext context) =>
      showAppSnackBar(ScaffoldMessenger.of(context), 'Coming soon');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const ScreenTitle('Profile'),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: IconButton(
                      onPressed: () => _logout(context),
                      icon: Icon(
                        Icons.logout,
                        size: 24.sp,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final cubit = context.read<ProfileCubit>();

                  if (state is ProfileErrorState) {
                    return ErrorView(onRetry: cubit.getProfile);
                  }
                  if (state is! ProfileSuccessState) {
                    return const LoadingView();
                  }

                  final profile = state.profile;
                  return RefreshIndicator(
                    color: AppColors.mainColor,
                    onRefresh: cubit.getProfile,
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      children: [
                        Row(
                          children: [
                            ProfileAvatar(profile: profile, radius: 31.r),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.name,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: AppColors.darkColor,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    profile.email,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.darkgreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 28.h),
                        _ProfileTile(
                          title: 'My Orders',
                          onTap: () => _comingSoon(context),
                        ),
                        _ProfileTile(
                          title: 'Edit Profile',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.editProfile,
                          ),
                        ),
                        _ProfileTile(
                          title: 'Reset Password',
                          onTap: () => _comingSoon(context),
                        ),
                        _ProfileTile(
                          title: 'FAQ',
                          onTap: () => _comingSoon(context),
                        ),
                        _ProfileTile(
                          title: 'Contact Us',
                          onTap: () => _comingSoon(context),
                        ),
                        _ProfileTile(
                          title: 'Privacy & Terms',
                          onTap: () => _comingSoon(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.darkColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: AppColors.darkColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
