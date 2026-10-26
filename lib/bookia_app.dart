import 'package:bookia_app/core/routes/app_router.dart';
import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/featuers/home/presentation/ui/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookiaApp extends StatelessWidget {
  const BookiaApp({super.key});

  String initPage() {
    final token = LocalHelper.token;
    if (token != null && token.isNotEmpty) {
      return AppRoutes.HomeScreen;
    }
    return AppRoutes.WelcomeScreen;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          fontFamily: 'DM',
          scaffoldBackgroundColor: AppColors.bgColor,
        ),
        initialRoute: initPage(),
        onGenerateRoute: AppRouter().onGenerateRoute,
      ),
    );
  }
}
