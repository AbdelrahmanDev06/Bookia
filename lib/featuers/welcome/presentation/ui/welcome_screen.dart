import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/main_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/splashscreen.png', fit: BoxFit.cover),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  Image.asset('assets/images/logo 2.png', width: 200.w),
                  SizedBox(height: 22.h),
                  Text(
                    'Order Your Books Now'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.darkColor,
                    ),
                  ),
                  const Spacer(),
                  MainButton(
                    text: 'login'.tr(),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.loginScreen),
                  ),
                  SizedBox(height: 15.h),
                  MainButton.outlined(
                    text: 'register'.tr(),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.registerScreen),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
