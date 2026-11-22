import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/utils/app_validator.dart';
import 'package:bookia_app/core/widgets/app_page.dart';
import 'package:bookia_app/core/widgets/custom_text_field.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/profile/presentation/cubit/profile_cubit.dart';
import 'package:bookia_app/featuers/support/data/support_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  final _subject = TextEditingController();
  final _message = TextEditingController();
  bool _loading = false;
  StoreInfo? _info;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().profile;
    _name = TextEditingController(text: profile?.name);
    _email = TextEditingController(text: profile?.email);
    SupportRepo.getStoreInfo().then((result) {
      if (!mounted) return;
      result.fold((_) {}, (info) => setState(() => _info = info));
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _loading = true);

    final result = await SupportRepo.contactUs(
      name: _name.text.trim(),
      email: _email.text.trim(),
      subject: _subject.text.trim(),
      message: _message.text.trim(),
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
    final info = _info;
    return AppPage(
      title: 'Contact Us',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (info != null) ...[
                for (final phone in info.phones)
                  _InfoTile(icon: Icons.phone_outlined, text: phone),
                for (final mail in info.mails)
                  _InfoTile(icon: Icons.email_outlined, text: mail),
                if (info.address.isNotEmpty)
                  _InfoTile(
                    icon: Icons.location_on_outlined,
                    text: info.address,
                  ),
                SizedBox(height: 16.h),
              ],
              CustomTextField(
                controller: _name,
                hint: 'Name',
                validator: AppValidator.required,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                controller: _email,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: AppValidator.email,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                controller: _subject,
                hint: 'Subject',
                validator: AppValidator.required,
              ),
              SizedBox(height: 14.h),
              TextFormField(
                controller: _message,
                minLines: 4,
                maxLines: 6,
                validator: AppValidator.required,
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: const TextStyle(color: AppColors.grayColor),
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      bottom: LoadingButton(text: 'Send', loading: _loading, onPressed: _send),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: AppColors.mainColor),
          SizedBox(width: 10.w),
          Expanded(
            child: SelectableText(
              text,
              style: TextStyle(fontSize: 14.sp, color: AppColors.darkColor),
            ),
          ),
        ],
      ),
    );
  }
}
