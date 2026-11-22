import 'package:bookia_app/core/theme/app_colors.dart';
import 'package:bookia_app/core/utils/app_validator.dart';
import 'package:bookia_app/core/widgets/app_page.dart';
import 'package:bookia_app/core/widgets/custom_text_field.dart';
import 'package:bookia_app/core/widgets/state_views.dart';
import 'package:bookia_app/featuers/cart/presentation/cubit/cart_cubit.dart';
import 'package:bookia_app/featuers/order/data/models/order_models.dart';
import 'package:bookia_app/featuers/order/data/repo/order_repo.dart';
import 'package:bookia_app/featuers/order/presentation/ui/order_success_screen.dart';
import 'package:bookia_app/featuers/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _address;

  List<GovernorateModel>? _governorates;
  String? _governoratesError;
  int? _governorateId;
  bool _placing = false;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileCubit>().profile;
    _name = TextEditingController(text: profile?.name);
    _email = TextEditingController(text: profile?.email);
    _phone = TextEditingController(text: profile?.phone);
    _address = TextEditingController(text: profile?.address);
    _loadGovernorates();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _loadGovernorates() async {
    setState(() => _governoratesError = null);
    final result = await OrderRepo.getGovernorates();
    if (!mounted) return;
    result.fold(
      (failure) => setState(() => _governoratesError = failure.message),
      (list) => setState(() {
        _governorates = list;
        // try to preselect the city saved in the profile
        final city = context.read<ProfileCubit>().profile?.city.toLowerCase();
        if (city != null && city.isNotEmpty) {
          for (final g in list) {
            if (g.name.toLowerCase() == city) _governorateId = g.id;
          }
        }
      }),
    );
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final cartCubit = context.read<CartCubit>();
    setState(() => _placing = true);

    final result = await OrderRepo.placeOrder(
      governorateId: _governorateId!,
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      address: _address.text.trim(),
      email: _email.text.trim(),
    );
    if (!mounted) return;
    setState(() => _placing = false);

    result.fold(
      (failure) => showAppSnackBar(messenger, failure.message, isError: true),
      (_) {
        // the server empties the cart after placing the order
        cartCubit.getCart();
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
        );
      },
    );
  }

  Widget _governorateField() {
    final list = _governorates;
    if (_governoratesError != null) {
      return Row(
        children: [
          Expanded(
            child: Text(
              _governoratesError!,
              style: TextStyle(fontSize: 14.sp, color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: _loadGovernorates,
            child: const Text(
              'Retry',
              style: TextStyle(color: AppColors.mainColor),
            ),
          ),
        ],
      );
    }
    if (list == null) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: LoadingView(),
      );
    }

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: const BorderSide(color: AppColors.borderColor),
    );
    return DropdownButtonFormField<int>(
      initialValue: _governorateId,
      isExpanded: true,
      hint: const Text(
        'Governorate',
        style: TextStyle(color: AppColors.grayColor),
      ),
      items: [
        for (final g in list)
          DropdownMenuItem(value: g.id, child: Text(g.name)),
      ],
      onChanged: (v) => setState(() => _governorateId = v),
      validator: (v) => v == null ? 'Please select a governorate' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.mainColor),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartCubit>().state;
    final cart = cartState is CartSuccessState ? cartState.cart : null;

    return AppPage(
      title: 'Checkout',
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _name,
                hint: 'Full Name',
                validator: AppValidator.required,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                controller: _email,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: AppValidator.email,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                controller: _phone,
                hint: 'Phone',
                keyboardType: TextInputType.phone,
                validator: AppValidator.phone,
              ),
              SizedBox(height: 14.h),
              CustomTextField(
                controller: _address,
                hint: 'Address',
                validator: AppValidator.required,
              ),
              SizedBox(height: 14.h),
              _governorateField(),
              SizedBox(height: 24.h),
              if (cart != null) ...[
                Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 18.sp, color: AppColors.darkColor),
                ),
                SizedBox(height: 10.h),
                for (final item in cart.items)
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity} x ${item.name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.darkgreyColor,
                            ),
                          ),
                        ),
                        Text(
                          '\$ ${item.itemTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.darkColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(color: AppColors.borderColor),
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
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppColors.darkColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
              ],
            ],
          ),
        ),
      ),
      bottom: LoadingButton(
        text: 'Place Order',
        loading: _placing,
        onPressed: (cart == null || cart.items.isEmpty) ? null : _placeOrder,
      ),
    );
  }
}
