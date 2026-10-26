import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/custom_text_field.dart';
import 'package:bookia_app/core/widgets/main_button.dart';
import 'package:bookia_app/featuers/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().login(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailCtrl,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              final ok = RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              ).hasMatch(v.trim());
              return ok ? null : 'Enter a valid email';
            },
          ),
          SizedBox(height: 15.h),
          CustomTextField(
            controller: _passCtrl,
            hint: 'Enter your password',
            isPassword: true,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Password is required' : null,
          ),
          SizedBox(height: 30.h),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is LoadLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.mainColor),
                );
              }
              return MainButton(text: 'Login', onPressed: _submit);
            },
          ),
        ],
      ),
    );
  }
}
