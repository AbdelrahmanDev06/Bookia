import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  void _backHome(BuildContext context) =>
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.HomeScreen, (_) => false);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _backHome(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: const BoxDecoration(
                    color: AppColors.mainColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, size: 60.sp, color: Colors.white),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Order Placed!',
                  style: TextStyle(fontSize: 26.sp, color: AppColors.darkColor),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Your order has been placed successfully. '
                  'You can track it from My Orders.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.darkgreyColor,
                  ),
                ),
                const Spacer(),
                MainButton(
                  text: 'My Orders',
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.orders,
                    (route) => route.settings.name == AppRoutes.HomeScreen,
                  ),
                ),
                SizedBox(height: 14.h),
                MainButton.outlined(
                  text: 'Back To Home',
                  onPressed: () => _backHome(context),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
