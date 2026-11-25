part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoadingState extends CartState {}

final class CartSuccessState extends CartState {
  final CartModel cart;

  final int? busyItemId;

  CartSuccessState(this.cart, {this.busyItemId});
}

final class CartErrorState extends CartState {
  final String message;
  CartErrorState(this.message);
}
