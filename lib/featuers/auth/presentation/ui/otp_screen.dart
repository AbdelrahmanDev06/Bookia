import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/app_page.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/auth/data/repo/auth_repo.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/new_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email});

  final String email;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _length = 6;
  final _codeCtrl = TextEditingController();
  bool _loading = false;
  bool _resending = false;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeCtrl.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    if (code.length != _length) {
      showAppSnackBar(messenger, 'Enter the $_length digit code', isError: true);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    final result = await AuthRepo.checkForgetPasswordCode(
      email: widget.email,
      code: code,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    result.fold(
      (failure) => showAppSnackBar(messenger, failure.message, isError: true),
      (_) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NewPasswordScreen(code: code)),
      ),
    );
  }

  Future<void> _resend() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _resending = true);
    final result = await AuthRepo.forgetPassword(widget.email);
    if (!mounted) return;
    setState(() => _resending = false);
    result.fold(
      (failure) => showAppSnackBar(messenger, failure.message, isError: true),
      (message) => showAppSnackBar(messenger, message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'OTP Verification',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the verification code we just sent to ${widget.email}.',
              style: TextStyle(fontSize: 16.sp, color: AppColors.darkgreyColor),
            ),
            SizedBox(height: 32.h),
            TextField(
              controller: _codeCtrl,
              autofocus: true,
              maxLength: _length,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                fontSize: 26.sp,
                letterSpacing: 18.w,
                color: AppColors.darkColor,
              ),
              onSubmitted: (_) => _verify(),
              decoration: InputDecoration(
                counterText: '',
                hintText: '------',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.mainColor),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            LoadingButton(text: 'Verify', loading: _loading, onPressed: _verify),
            SizedBox(height: 16.h),
            Center(
              child: TextButton(
                onPressed: _resending ? null : _resend,
                child: Text(
                  _resending ? 'Sending...' : "Didn't receive the code? Resend",
                  style: const TextStyle(color: AppColors.mainColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
