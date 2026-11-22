import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/app_page.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/support/data/support_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  List<FaqModel>? _faqs;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    final result = await SupportRepo.getFaqs();
    if (!mounted) return;
    result.fold(
      (failure) => setState(() => _error = failure.message),
      (faqs) => setState(() => _faqs = faqs),
    );
  }

  @override
  Widget build(BuildContext context) {
    final faqs = _faqs;
    Widget body;
    if (_error != null) {
      body = ErrorView(message: _error!, onRetry: _load);
    } else if (faqs == null) {
      body = const LoadingView();
    } else {
      body = RefreshIndicator(
        color: AppColors.mainColor,
        onRefresh: _load,
        child: faqs.isEmpty
            ? ListView(
                children: [
                  SizedBox(height: 180.h),
                  const EmptyView(
                    icon: Icons.help_outline,
                    message: 'No questions yet',
                  ),
                ],
              )
            : ListView.separated(
                padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 20.h),
                itemCount: faqs.length,
                separatorBuilder: (_, _) => SizedBox(height: 10.h),
                itemBuilder: (context, i) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      iconColor: AppColors.mainColor,
                      collapsedIconColor: AppColors.darkColor,
                      title: Text(
                        faqs[i].question,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.darkColor,
                        ),
                      ),
                      childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                      expandedAlignment: AlignmentDirectional.centerStart,
                      children: [
                        Text(
                          faqs[i].answer,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.darkgreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    }
    return AppPage(title: 'FAQ', body: body);
  }
}
