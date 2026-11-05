import 'package:bookia_app/featuers/cart/presentation/cubit/cart_cubit.dart';
import 'package:bookia_app/featuers/cart/presentation/ui/cart_screen.dart';
import 'package:bookia_app/featuers/home/presentation/ui/home_screen.dart';
import 'package:bookia_app/featuers/home/presentation/ui/widgets/home_bottom_nav_bar.dart';
import 'package:bookia_app/featuers/profile/presentation/cubit/profile_cubit.dart';
import 'package:bookia_app/featuers/profile/presentation/ui/profile_screen.dart';
import 'package:bookia_app/featuers/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:bookia_app/featuers/wishlist/presentation/ui/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const _screens = [
    HomeScreen(),
    WishlistScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // load everything once so the bookmark state / cart are ready
    context.read<WishlistCubit>().getWishlist();
    context.read<CartCubit>().getCart();
    context.read<ProfileCubit>().getProfile();
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);

    // refresh the tab every time it's opened
    switch (index) {
      case 1:
        context.read<WishlistCubit>().getWishlist();
      case 2:
        context.read<CartCubit>().getCart();
      case 3:
        context.read<ProfileCubit>().getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
