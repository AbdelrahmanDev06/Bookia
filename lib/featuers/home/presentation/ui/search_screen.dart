import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/theme/app_text_style.dart';
import 'package:bookia_app/featuers/home/presentation/cubit/search_cubit.dart';
import 'package:bookia_app/featuers/home/presentation/ui/widgets/products_sliver_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 41.w,
                    height: 41.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18.sp,
                      color: AppColors.darkColor,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Builder(
                  builder: (context) => TextField(
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onChanged: context.read<SearchCubit>().onQueryChanged,
                    decoration: InputDecoration(
                      hintText: 'Search Store',
                      hintStyle: AppTextStyle.hintTextStyle,
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 24.sp,
                        color: AppColors.darkColor,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                      enabledBorder: _border(AppColors.borderColor),
                      focusedBorder: _border(AppColors.mainColor),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) {
                      if (state is SearchLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.mainColor,
                          ),
                        );
                      }

                      if (state is SearchErrorState) {
                        return const _Message('Something went wrong');
                      }

                      if (state is SearchSuccessState) {
                        if (state.products.isEmpty) {
                          return const _Message('No books found');
                        }
                        return CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.only(bottom: 24.h),
                              sliver: ProductsSliverGrid(
                                products: state.products,
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: BorderSide(color: color),
  );
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 18.sp, color: AppColors.darkColor),
      ),
    );
  }
}
