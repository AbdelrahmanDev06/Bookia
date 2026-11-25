import 'package:bookia_app/core/routes/app_router.dart';
import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/services/dio_provider.dart';
import 'package:bookia_app/core/services/local_helper.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/cart/presentation/cubit/cart_cubit.dart';
import 'package:bookia_app/featuers/profile/presentation/cubit/profile_cubit.dart';
import 'package:bookia_app/featuers/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookiaApp extends StatefulWidget {
  const BookiaApp({super.key});

  @override
  State<BookiaApp> createState() => _BookiaAppState();
}

class _BookiaAppState extends State<BookiaApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _handlingUnauthorized = false;

  @override
  void initState() {
    super.initState();
    DioProvider.onUnauthorized = _onUnauthorized;
  }

  @override
  void dispose() {
    DioProvider.onUnauthorized = null;
    super.dispose();
  }

  String _initPage() {
    final token = LocalHelper.token;
    if (token != null && token.isNotEmpty) {
      return AppRoutes.HomeScreen;
    }
    return AppRoutes.WelcomeScreen;
  }

  void _onUnauthorized() {
    final context = _navigatorKey.currentContext;
    if (_handlingUnauthorized || context == null) return;
    _handlingUnauthorized = true;

    context.read<WishlistCubit>().clear();
    context.read<CartCubit>().clear();
    context.read<ProfileCubit>().reset();

    _navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRoutes.loginScreen,
      (_) => false,
    );
    final messenger = _messengerKey.currentState;
    if (messenger != null) {
      showAppSnackBar(
        messenger,
        'Your session has expired, please login again',
        isError: true,
      );
    }
    Future.delayed(const Duration(seconds: 2), () {
      _handlingUnauthorized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WishlistCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          title: 'Bookia',
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          scaffoldMessengerKey: _messengerKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            fontFamily: 'DM',
            scaffoldBackgroundColor: AppColors.bgColor,
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.mainColor),
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: AppColors.mainColor,
            ),
          ),
          initialRoute: _initPage(),
          onGenerateRoute: AppRouter().onGenerateRoute,
        ),
      ),
    );
  }
}
