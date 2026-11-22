import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/widgets/app_page.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/order/data/models/order_models.dart';
import 'package:bookia_app/featuers/order/data/repo/order_repo.dart';
import 'package:bookia_app/featuers/order/presentation/ui/widgets/order_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  OrderDetailsModel? _order;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    final result = await OrderRepo.getOrder(widget.orderId);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() => _error = failure.message),
      (order) => setState(() => _order = order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    return AppPage(
      title: 'Order Details',
      body: _error != null
          ? ErrorView(message: _error!, onRetry: _load)
          : order == null
              ? const LoadingView()
              : ListView(
                  padding: EdgeInsets.fromLTRB(22.w, 0, 22.w, 20.h),
                  children: [
                    _Section(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Order #${order.code}',
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: AppColors.darkColor,
                                ),
                              ),
                            ),
                            OrderStatusChip(order.status),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        _InfoRow('Date', order.date),
                      ],
                    ),
                    _Section(
                      title: 'Shipping Info',
                      children: [
                        _InfoRow('Name', order.name),
                        _InfoRow('Phone', order.phone),
                        _InfoRow('Email', order.email),
                        _InfoRow('Governorate', order.governorate),
                        _InfoRow('Address', order.address),
                        if (order.notes.isNotEmpty)
                          _InfoRow('Notes', order.notes),
                      ],
                    ),
                    _Section(
                      title: 'Products',
                      children: [
                        for (final p in order.products)
                          Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${p.quantity} x ${p.name}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.darkColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$ ${p.total.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.darkColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    _Section(
                      children: [
                        _InfoRow(
                          'Subtotal',
                          '\$ ${order.subTotal.toStringAsFixed(2)}',
                        ),
                        if (order.discount > 0)
                          _InfoRow(
                            'Discount',
                            '\$ ${order.discount.toStringAsFixed(2)}',
                          ),
                        _InfoRow(
                          'Total',
                          '\$ ${order.total.toStringAsFixed(2)}',
                          bold: true,
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(fontSize: 16.sp, color: AppColors.mainColor),
            ),
            SizedBox(height: 10.h),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: bold ? 16.sp : 14.sp,
                color: AppColors.darkgreyColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: bold ? 16.sp : 14.sp,
                color: AppColors.darkColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
