import 'package:bookia_app/core/utils/app_validator.dart';
import 'package:bookia_app/core/widgets/app_page.dart';
import 'package:bookia_app/core/widgets/custom_text_field.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/profile/data/repo/profile_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _loading = true);

    final result = await ProfileRepo.changePassword(
      currentPassword: _current.text,
      newPassword: _new.text,
      confirmPassword: _confirm.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);

    result.fold(
      (failure) => showAppSnackBar(messenger, failure.message, isError: true),
      (message) {
        showAppSnackBar(messenger, message);
        navigator.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Reset Password',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10.h),
              CustomTextField(
                controller: _current,
                hint: 'Current Password',
                isPassword: true,
                validator: AppValidator.required,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                controller: _new,
                hint: 'New Password',
                isPassword: true,
                validator: AppValidator.password,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                controller: _confirm,
                hint: 'Confirm Password',
                isPassword: true,
                validator: AppValidator.confirm(() => _new.text),
              ),
            ],
          ),
        ),
      ),
      bottom: LoadingButton(
        text: 'Update Password',
        loading: _loading,
        onPressed: _submit,
      ),
    );
  }
}
