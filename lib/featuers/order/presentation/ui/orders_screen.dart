import 'package:bookia_app/core/routes/app_routes.dart';
import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/app_page.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/order/data/models/order_models.dart';
import 'package:bookia_app/featuers/order/presentation/cubit/orders_cubit.dart';
import 'package:bookia_app/featuers/order/presentation/ui/widgets/order_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit()..getOrders(),
      child: AppPage(
        title: 'My Orders',
        body: BlocBuilder<OrdersCubit, OrdersState>(
          builder: (context, state) {
            final cubit = context.read<OrdersCubit>();
            if (state is OrdersErrorState) {
              return ErrorView(message: state.message, onRetry: cubit.getOrders);
            }
            if (state is! OrdersSuccessState) return const LoadingView();

            return RefreshIndicator(
              color: AppColors.mainColor,
              onRefresh: cubit.getOrders,
              child: state.orders.isEmpty
                  ? ListView(
                      children: [
                        SizedBox(height: 180.h),
                        const EmptyView(
                          icon: Icons.receipt_long_outlined,
                          message: "You don't have any orders yet",
                        ),
                      ],
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (n) {
                        if (n.metrics.extentAfter < 200) cubit.loadMore();
                        return false;
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 20.h),
                        itemCount:
                            state.orders.length + (state.loadingMore ? 1 : 0),
                        separatorBuilder: (_, _) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          if (index >= state.orders.length) {
                            return const LoadingView();
                          }
                          return _OrderCard(order: state.orders[index]);
                        },
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderSummaryModel order;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.orderDetails,
          arguments: order.id,
        ),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.code}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.darkColor,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      order.date,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.darkgreyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OrderStatusChip(order.status),
                  SizedBox(height: 6.h),
                  Text(
                    '\$ ${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.darkColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
