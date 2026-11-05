import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/custom_text_field.dart';
import 'package:bookia_app/core/widgets/main_button.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/profile/presentation/cubit/profile_cubit.dart';
import 'package:bookia_app/featuers/profile/presentation/ui/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _city;
  late final TextEditingController _address;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().profile;
    _name = TextEditingController(text: profile?.name);
    _phone = TextEditingController(text: profile?.phone);
    _city = TextEditingController(text: profile?.city);
    _address = TextEditingController(text: profile?.address);
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _city.dispose();
    _address.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'This field is required' : null;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _loading = true);

    final ok = await context.read<ProfileCubit>().updateProfile(
          name: _name.text.trim(),
          phone: _phone.text.trim(),
          city: _city.text.trim(),
          address: _address.text.trim(),
        );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      showAppSnackBar(messenger, 'Profile updated successfully');
      navigator.pop();
    } else {
      showAppSnackBar(messenger, 'Failed to update profile', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileCubit>().profile;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SquareBackButton(),
                  ),
                  const ScreenTitle('Edit Profile'),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 22.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      ProfileAvatar(profile: profile, radius: 50.r),
                      SizedBox(height: 32.h),
                      CustomTextField(
                        controller: _name,
                        hint: 'Full Name',
                        validator: _required,
                      ),
                      SizedBox(height: 14.h),
                      CustomTextField(
                        controller: _phone,
                        hint: 'Phone',
                        keyboardType: TextInputType.phone,
                        validator: _required,
                      ),
                      SizedBox(height: 14.h),
                      CustomTextField(controller: _city, hint: 'City'),
                      SizedBox(height: 14.h),
                      CustomTextField(controller: _address, hint: 'Address'),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(22.w, 8.h, 22.w, 20.h),
              child: _loading
                  ? SizedBox(
                      height: 56.h,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.mainColor,
                        ),
                      ),
                    )
                  : MainButton(text: 'Update Profile', onPressed: _submit),
            ),
          ],
        ),
      ),
    );
  }
}
