import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/login_screen.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/register_screen.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/presentation/ui/book_details_screen.dart';
import 'package:bookia_app/featuers/home/presentation/ui/home_screen.dart';
import 'package:bookia_app/featuers/home/presentation/ui/search_screen.dart';
import 'package:bookia_app/featuers/welcome/presentation/ui/welcome_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.WelcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case AppRoutes.HomeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case AppRoutes.bookDetails:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => BookDetailsScreen(product: product),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
