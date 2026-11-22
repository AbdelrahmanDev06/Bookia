import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip(this.status, {super.key});

  final String status;

  Color get _color => switch (status.toLowerCase()) {
        'delivered' || 'completed' => Colors.green,
        'shipping' || 'shipped' => Colors.blue,
        'cancelled' || 'canceled' || 'rejected' => Colors.red,
        'pending' => Colors.orange,
        _ => AppColors.mainColor,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.isEmpty ? '-' : status,
        style: TextStyle(fontSize: 12.sp, color: _color),
      ),
    );
  }
}
