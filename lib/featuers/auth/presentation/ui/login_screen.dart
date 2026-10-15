import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.registerScreen);
            },
            icon: Icon(Icons.abc, color: AppColors.mainColor),
          ),
          Text(
            "Welcome Back! Glad to see you again!",
            style: AppTextStyle.font30Regular,
          ),
        ],
      ),
    );
  }
}
