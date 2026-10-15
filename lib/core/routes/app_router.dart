import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/login_screen.dart';
import 'package:bookia_app/featuers/welcome/presentation/ui/welcome_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginScreen:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.WelcomeScreen:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
