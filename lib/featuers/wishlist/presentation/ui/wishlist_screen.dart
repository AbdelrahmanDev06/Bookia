import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            const ScreenTitle('Wishlist'),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  final cubit = context.read<WishlistCubit>();

                  if (state is WishlistSuccessState) {
                    if (state.products.isEmpty) {
                      return RefreshIndicator(
                        color: AppColors.mainColor,
                        onRefresh: cubit.getWishlist,
                        child: ListView(
                          children: [
                            SizedBox(height: 200.h),
                            const EmptyView(
                              icon: Icons.bookmark_border,
                              message: 'Your wishlist is empty',
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.mainColor,
                      onRefresh: cubit.getWishlist,
                      child: GridView.builder(
                        padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 24.h),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 11.w,
                          mainAxisSpacing: 14.h,
                          childAspectRatio: 0.58,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) =>
                            _WishlistCard(product: state.products[index]),
                      ),
                    );
                  }

                  if (state is WishlistErrorState) {
                    return ErrorView(onRetry: cubit.getWishlist);
                  }

                  return const LoadingView();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WishlistCard extends StatelessWidget {
  const _WishlistCard({required this.product});

  final ProductModel product;

  Future<void> _remove(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok =
        await context.read<WishlistCubit>().removeFromWishlist(product.id);
    showAppSnackBar(
      messenger,
      ok ? 'Removed from wishlist' : 'Failed to remove, try again',
      isError: !ok,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.bookDetails,
        arguments: product,
      ),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    product.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.bgColor,
                      child: const Icon(
                        Icons.menu_book_outlined,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.sp, color: AppColors.darkColor),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.formattedPrice,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.darkColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _remove(context),
                  child: Icon(
                    Icons.highlight_off,
                    size: 22.sp,
                    color: AppColors.darkColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
