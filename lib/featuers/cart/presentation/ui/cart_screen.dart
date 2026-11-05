import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/utils/price_formatter.dart';
import 'package:bookia_app/core/widgets/main_button.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/cart/data/models/cart_model.dart';
import 'package:bookia_app/featuers/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            const ScreenTitle('My Cart'),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  final cubit = context.read<CartCubit>();

                  if (state is CartSuccessState) {
                    final cart = state.cart;
                    return Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator(
                            color: AppColors.mainColor,
                            onRefresh: cubit.getCart,
                            child: cart.items.isEmpty
                                ? ListView(
                                    children: [
                                      SizedBox(height: 180.h),
                                      const EmptyView(
                                        icon: Icons.shopping_cart_outlined,
                                        message: 'Your cart is empty',
                                      ),
                                    ],
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 22.w,
                                    ),
                                    itemCount: cart.items.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 12.h),
                                    itemBuilder: (context, index) {
                                      final item = cart.items[index];
                                      return _CartItemCard(
                                        item: item,
                                        isBusy:
                                            state.busyItemId == item.itemId,
                                      );
                                    },
                                  ),
                          ),
                        ),
                        _CartFooter(cart: cart),
                      ],
                    );
                  }

                  if (state is CartErrorState) {
                    return ErrorView(onRetry: cubit.getCart);
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

class _CartFooter extends StatelessWidget {
  const _CartFooter({required this.cart});

  final CartModel cart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 16.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.darkgreyColor,
                ),
              ),
              Text(
                '\$ ${cart.total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18.sp, color: AppColors.darkColor),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          MainButton(
            text: 'Checkout',
            onPressed: cart.items.isEmpty
                ? null
                : () => showAppSnackBar(
                      ScaffoldMessenger.of(context),
                      'Checkout is coming soon',
                    ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  const _CartItemCard({required this.item, required this.isBusy});

  final CartItemModel item;
  final bool isBusy;

  Future<void> _run(
    BuildContext context,
    Future<bool> Function(CartCubit cubit) action,
    String errorMessage,
  ) async {
    if (isBusy) return;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await action(context.read<CartCubit>());
    if (!ok) showAppSnackBar(messenger, errorMessage, isError: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Image.network(
              item.image,
              width: 80.w,
              height: 90.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80.w,
                height: 90.h,
                color: AppColors.bgColor,
                child: const Icon(
                  Icons.menu_book_outlined,
                  color: AppColors.grayColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.darkColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _run(
                        context,
                        (cubit) => cubit.removeItem(item),
                        'Failed to remove item',
                      ),
                      child: Icon(
                        Icons.highlight_off,
                        size: 22.sp,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  formatPrice(item.priceAfterDiscount),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.darkgreyColor,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: () => _run(
                        context,
                        (cubit) => cubit.increment(item),
                        'No more items in stock',
                      ),
                    ),
                    SizedBox(
                      width: 42.w,
                      child: Center(
                        child: isBusy
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.mainColor,
                                ),
                              )
                            : Text(
                                item.quantity.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.darkColor,
                                ),
                              ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: () => _run(
                        context,
                        (cubit) => cubit.decrement(item),
                        'Minimum quantity is 1',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      formatPrice(item.itemTotal),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26.w,
        height: 26.w,
        decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Icon(icon, size: 18.sp, color: AppColors.darkColor),
      ),
    );
  }
}
