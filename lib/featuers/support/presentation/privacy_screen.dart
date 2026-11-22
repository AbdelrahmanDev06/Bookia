import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/app_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  static const _sections = [
    (
      'Information We Collect',
      'When you create an account we collect your name, email address and, '
          'when you place an order, your phone number and shipping address.',
    ),
    (
      'How We Use Your Information',
      'Your information is used only to manage your account, process and '
          'deliver your orders, and reply to your messages. We do not sell '
          'your personal data to third parties.',
    ),
    (
      'Orders & Payment',
      'Prices shown in the app include any active discounts. An order is '
          'confirmed once it is placed and you can follow its status from '
          'My Orders.',
    ),
    (
      'Your Account',
      'You are responsible for keeping your password safe. You can update '
          'your profile or change your password at any time from the Profile '
          'tab.',
    ),
    (
      'Contact',
      'If you have any question about these terms, reach us from the '
          'Contact Us page.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Privacy & Terms',
      body: ListView(
        padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 20.h),
        children: [
          for (final (title, body) in _sections) ...[
            Text(
              title,
              style: TextStyle(fontSize: 18.sp, color: AppColors.darkColor),
            ),
            SizedBox(height: 6.h),
            Text(
              body,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.5,
                color: AppColors.darkgreyColor,
              ),
            ),
            SizedBox(height: 18.h),
          ],
        ],
      ),
    );
  }
}
