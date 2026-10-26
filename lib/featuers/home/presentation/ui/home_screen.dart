import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/main_button.dart';
import 'package:bookia_app/featuers/home/presentation/cubit/home_cubit.dart';
import 'package:bookia_app/featuers/home/presentation/ui/widgets/home_banner.dart';
import 'package:bookia_app/featuers/home/presentation/ui/widgets/home_bottom_nav_bar.dart';
import 'package:bookia_app/featuers/home/presentation/ui/widgets/home_header.dart';
import 'package:bookia_app/featuers/home/presentation/ui/widgets/products_sliver_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..getHomeData(),
      child: Scaffold(
        bottomNavigationBar: const HomeBottomNavBar(),
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccessState) {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            const HomeHeader(),
                            SizedBox(height: 20.h),
                            HomeBanner(
                              images: state.sliders
                                  .map((slider) => slider.image)
                                  .toList(),
                            ),
                            SizedBox(height: 28.h),
                            const _SectionTitle('Best Seller'),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      sliver: ProductsSliverGrid(products: state.bestSellers),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 16.h),
                        child: const _SectionTitle('All Products'),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 24.h),
                      sliver: ProductsSliverGrid(products: state.products),
                    ),
                  ],
                );
              }

              if (state is HomeErrorState) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Something went wrong',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.darkColor,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        MainButton(
                          text: 'Try again',
                          onPressed: () =>
                              context.read<HomeCubit>().getHomeData(),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(color: AppColors.mainColor),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 24.sp, color: AppColors.darkColor),
    );
  }
}
