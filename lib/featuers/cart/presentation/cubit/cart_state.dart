part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoadingState extends CartState {}

final class CartSuccessState extends CartState {
  final CartModel cart;

  /// item currently being updated / removed (to show a small loader on it)
  final int? busyItemId;

  CartSuccessState(this.cart, {this.busyItemId});
}

final class CartErrorState extends CartState {}
