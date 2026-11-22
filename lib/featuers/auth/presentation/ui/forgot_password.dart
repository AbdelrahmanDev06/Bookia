import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/utils/app_validator.dart';
import 'package:bookia_app/core/widgets/custom_text_field.dart';
import 'package:bookia_app/core/widgets/main_button.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/auth/presentation/cubit/auth_cubit.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/otp_screen.dart';
import 'package:bookia_app/featuers/profile/presentation/ui/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().forgetPassword(_emailCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state is ForgetPasswordSuccessState) {
            showAppSnackBar(messenger, state.message);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtpScreen(email: _emailCtrl.text.trim()),
              ),
            );
          } else if (state is ForgetPasswordErrorState) {
            showAppSnackBar(messenger, state.message, isError: true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 22.w,
                  vertical: 20.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SquareBackButton(),
                      SizedBox(height: 28.h),
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: AppColors.darkColor,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Don't worry! Please enter the email address linked "
                        'with your account.',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.darkgreyColor,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      CustomTextField(
                        controller: _emailCtrl,
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validator: AppValidator.email,
                      ),
                      SizedBox(height: 30.h),
                      if (state is LoadLoadingState)
                        const LoadingView()
                      else
                        MainButton(
                          text: 'Send Code',
                          onPressed: () => _submit(context),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
