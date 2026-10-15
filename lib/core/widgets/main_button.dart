import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainButton extends StatelessWidget {
  /// Filled gold button (Login).
  const MainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.mainColor,
    this.textColor = Colors.white,
    this.borderColor,
  });

  /// White button with dark border (Register).
  const MainButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = AppColors.darkColor,
    this.borderColor = AppColors.darkColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: 'DM',
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: textColor,
    );

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          textStyle: textStyle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: borderColor == null
                ? BorderSide.none
                : BorderSide(color: borderColor!),
          ),
        ),
        child: Text(text, style: textStyle),
      ),
    );
  }
}
