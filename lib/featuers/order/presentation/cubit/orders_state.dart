part of 'orders_cubit.dart';

@immutable
sealed class OrdersState {}

final class OrdersLoadingState extends OrdersState {}

final class OrdersSuccessState extends OrdersState {
  final List<OrderSummaryModel> orders;
  final bool hasMore;
  final bool loadingMore;

  OrdersSuccessState(
    this.orders, {
    this.hasMore = false,
    this.loadingMore = false,
  });
}

final class OrdersErrorState extends OrdersState {
  final String message;
  OrdersErrorState(this.message);
}
