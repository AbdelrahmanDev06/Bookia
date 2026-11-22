import 'package:bookia_app/featuers/order/data/models/order_models.dart';
import 'package:bookia_app/featuers/order/data/repo/order_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersLoadingState());

  int _page = 1;

  Future<void> getOrders() async {
    if (state is! OrdersSuccessState) emit(OrdersLoadingState());
    final result = await OrderRepo.getOrders();
    result.fold(
      (failure) {
        if (state is! OrdersSuccessState) emit(OrdersErrorState(failure.message));
      },
      (page) {
        _page = page.currentPage;
        emit(OrdersSuccessState(page.orders, hasMore: page.hasMore));
      },
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! OrdersSuccessState ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(OrdersSuccessState(current.orders, hasMore: true, loadingMore: true));

    final result = await OrderRepo.getOrders(page: _page + 1);
    result.fold(
      (_) => emit(OrdersSuccessState(current.orders, hasMore: true)),
      (page) {
        _page = page.currentPage;
        emit(OrdersSuccessState(
          [...current.orders, ...page.orders],
          hasMore: page.hasMore,
        ));
      },
    );
  }
}
