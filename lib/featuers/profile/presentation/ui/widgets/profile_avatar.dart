import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/featuers/profile/data/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.profile, required this.radius});

  final ProfileModel? profile;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hasImage = profile?.hasImage ?? false;
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFD9D9D9),
      foregroundImage: hasImage ? NetworkImage(profile!.image) : null,
      onForegroundImageError: hasImage ? (_, __) {} : null,
      child: Icon(
        Icons.person,
        size: radius,
        color: AppColors.grayColor.withValues(alpha: 0.6),
      ),
    );
  }
}

class SquareBackButton extends StatelessWidget {
  const SquareBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 41.w,
        height: 41.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 18.sp,
          color: AppColors.darkColor,
        ),
      ),
    );
  }
}
