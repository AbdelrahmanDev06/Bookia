import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/auth/presentation/cubit/auth_cubit.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/widgets/register_form.dart';
import 'package:bookia_app/featuers/profile/presentation/ui/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state is RegisterSuccessState) {
            showAppSnackBar(messenger, state.message);
            final token = LocalHelper.token;
            final loggedIn = token != null && token.isNotEmpty;
            Navigator.pushNamedAndRemoveUntil(
              context,
              loggedIn ? AppRoutes.HomeScreen : AppRoutes.loginScreen,
              (_) => false,
            );
          } else if (state is RegisterErrorState) {
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
                    'Hello! Register to get started',
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: AppColors.darkColor,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  const RegisterForm(),
                  SizedBox(height: 20.h),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.loginScreen,
                      ),
                      child: const Text(
                        'Already have an account? Login Now',
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
