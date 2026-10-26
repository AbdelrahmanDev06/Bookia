import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/featuers/auth/presentation/cubit/auth_cubit.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/login_screen.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/register_screen.dart';
import 'package:bookia_app/featuers/home/presentation/ui/home_screen.dart';
import 'package:bookia_app/featuers/welcome/presentation/ui/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (context) => AuthCubit(),
              child: LoginScreen(),
            );
          },
        );

      case AppRoutes.registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.HomeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.WelcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
