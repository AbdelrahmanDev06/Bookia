import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/auth/presentation/cubit/auth_cubit.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/forgot_password.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/widgets/login_form.dart';
import 'package:bookia_app/featuers/profile/presentation/ui/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state is LoginSuccessState) {
            showAppSnackBar(messenger, 'Logged in successfully');
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.HomeScreen,
              (_) => false,
            );
          } else if (state is LoginErrorState) {
            showAppSnackBar(messenger, state.message, isError: true);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Navigator.canPop(context)) const SquareBackButton(),
                  SizedBox(height: 28.h),
                  Text(
                    'Welcome back! Glad to see you, Again!',
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: AppColors.darkColor,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  const LoginForm(),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgetPasswordScreen(),
                        ),
                      ),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: AppColors.darkgreyColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.registerScreen,
                      ),
                      child: const Text(
                        "Don't have an account? Register Now",
                        style: TextStyle(color: AppColors.mainColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
