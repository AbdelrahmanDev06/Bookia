import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/main_button.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/presentation/cubit/book_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookDetailsCubit(product)..getDetails(),
      child: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          final book = state is BookDetailsSuccessState
              ? state.product
              : product;

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SquareButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: () => Navigator.pop(context),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.bookmark_border,
                            size: 26.sp,
                            color: AppColors.darkColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(
                        children: [
                          SizedBox(height: 24.h),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Image.network(
                              book.image,
                              width: 150.w,
                              height: 220.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 150.w,
                                    height: 220.h,
                                    color: AppColors.borderColor,
                                    child: const Icon(
                                      Icons.menu_book_outlined,
                                      color: AppColors.grayColor,
                                    ),
                                  ),
                            ),
                          ),
                          SizedBox(height: 22.h),
                          Text(
                            book.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: AppColors.darkColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            book.category,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.mainColor,
                            ),
                          ),
                          SizedBox(height: 22.h),
                          Text(
                            book.plainDescription,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.5,
                              color: AppColors.darkColor,
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 20.h),
                    child: Row(
                      children: [
                        Text(
                          book.formattedPrice,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: AppColors.darkColor,
                          ),
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          child: MainButton(
                            text: 'Add To Cart',
                            backgroundColor: AppColors.darkColor,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 41.w,
        height: 41.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Icon(icon, size: 18.sp, color: AppColors.darkColor),
      ),
    );
  }
}
