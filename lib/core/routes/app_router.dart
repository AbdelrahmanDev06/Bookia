import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/login_screen.dart';
import 'package:bookia_app/featuers/auth/presentation/ui/register_screen.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/presentation/ui/book_details_screen.dart';
import 'package:bookia_app/featuers/home/presentation/ui/search_screen.dart';
import 'package:bookia_app/featuers/main/presentation/ui/main_screen.dart';
import 'package:bookia_app/featuers/order/presentation/ui/checkout_screen.dart';
import 'package:bookia_app/featuers/order/presentation/ui/order_details_screen.dart';
import 'package:bookia_app/featuers/order/presentation/ui/orders_screen.dart';
import 'package:bookia_app/featuers/profile/presentation/ui/change_password_screen.dart';
import 'package:bookia_app/featuers/profile/presentation/ui/edit_profile_screen.dart';
import 'package:bookia_app/featuers/support/presentation/contact_us_screen.dart';
import 'package:bookia_app/featuers/support/presentation/faq_screen.dart';
import 'package:bookia_app/featuers/support/presentation/privacy_screen.dart';
import 'package:bookia_app/featuers/welcome/presentation/ui/welcome_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    Route page(Widget child) =>
        MaterialPageRoute(settings: settings, builder: (_) => child);

    switch (settings.name) {
      case AppRoutes.loginScreen:
        return page(const LoginScreen());
      case AppRoutes.registerScreen:
        return page(const RegisterScreen());
      case AppRoutes.WelcomeScreen:
        return page(const WelcomeScreen());
      case AppRoutes.HomeScreen:
        // home opens the main screen that holds the bottom nav bar
        return page(const MainScreen());
      case AppRoutes.search:
        return page(const SearchScreen());
      case AppRoutes.editProfile:
        return page(const EditProfileScreen());
      case AppRoutes.changePassword:
        return page(const ChangePasswordScreen());
      case AppRoutes.bookDetails:
        return page(BookDetailsScreen(product: settings.arguments as ProductModel));
      case AppRoutes.checkout:
        return page(const CheckoutScreen());
      case AppRoutes.orders:
        return page(const OrdersScreen());
      case AppRoutes.orderDetails:
        return page(OrderDetailsScreen(orderId: settings.arguments as int));
      case AppRoutes.faq:
        return page(const FaqScreen());
      case AppRoutes.contactUs:
        return page(const ContactUsScreen());
      case AppRoutes.privacy:
        return page(const PrivacyScreen());
      default:
        return page(
          Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
