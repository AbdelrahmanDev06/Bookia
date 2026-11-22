import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/utils/app_validator.dart';
import 'package:bookia_app/core/widgets/app_page.dart';
import 'package:bookia_app/core/widgets/custom_text_field.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.code});

  final String code;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _loading = true);

    final result = await AuthRepo.resetPassword(
      code: widget.code,
      password: _password.text,
      confirmPassword: _confirm.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    result.fold(
      (failure) => showAppSnackBar(messenger, failure.message, isError: true),
      (message) {
        showAppSnackBar(messenger, message);
        navigator.pushNamedAndRemoveUntil(
          AppRoutes.loginScreen,
          (route) => route.settings.name == AppRoutes.WelcomeScreen,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'New Password',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your new password must be different from previously used '
                'passwords.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.darkgreyColor,
                ),
              ),
              SizedBox(height: 32.h),
              CustomTextField(
                controller: _password,
                hint: 'New Password',
                isPassword: true,
                validator: AppValidator.password,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                controller: _confirm,
                hint: 'Confirm Password',
                isPassword: true,
                validator: AppValidator.confirm(() => _password.text),
              ),
              SizedBox(height: 30.h),
              LoadingButton(
                text: 'Reset Password',
                loading: _loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
