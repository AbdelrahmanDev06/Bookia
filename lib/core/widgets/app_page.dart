import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/main_button.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/profile/presentation/ui/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.body,
    this.bottom,
  });

  final String title;
  final Widget body;

  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SquareBackButton(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48.w),
                    child: ScreenTitle(title),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(child: body),
            if (bottom != null)
              Padding(
                padding: EdgeInsets.fromLTRB(22.w, 8.h, 22.w, 20.h),
                child: bottom,
              ),
          ],
        ),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.text,
    required this.loading,
    required this.onPressed,
  });

  final String text;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        height: 56.h,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.mainColor),
        ),
      );
    }
    return MainButton(text: text, onPressed: onPressed);
  }
}
