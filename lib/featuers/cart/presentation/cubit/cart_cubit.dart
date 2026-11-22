import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookia_app/featuers/cart/data/models/cart_model.dart';
import 'package:bookia_app/featuers/cart/data/repo/cart_repo.dart';
import 'package:flutter/foundation.dart';
part 'cart_state.dart';

/// action methods return `null` on success, or the error message on failure
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  CartModel? get _cart {
    final current = state;
    return current is CartSuccessState ? current.cart : null;
  }

  Future<void> getCart() async {
    if (_cart == null) emit(CartLoadingState());

    final result = await CartRepo.getCart();
    result.fold(
      (failure) {
        // keep showing the old cart if we already have one
        if (_cart == null) emit(CartErrorState(failure.message));
      },
      (cart) => emit(CartSuccessState(cart)),
    );
  }

  Future<String?> addToCart(int productId) async {
    final result = await CartRepo.addToCart(productId);
    return result.fold<String?>((failure) => failure.message, (cart) {
      emit(CartSuccessState(cart));
      return null;
    });
  }

  Future<String?> increment(CartItemModel item) async {
    if (item.stock > 0 && item.quantity >= item.stock) {
      return 'No more items in stock';
    }
    return _updateQuantity(item, item.quantity + 1);
  }

  Future<String?> decrement(CartItemModel item) async {
    if (item.quantity <= 1) return 'Minimum quantity is 1';
    return _updateQuantity(item, item.quantity - 1);
  }

  Future<String?> _updateQuantity(CartItemModel item, int quantity) async {
    final old = _cart;
    if (old == null) return 'Cart is not loaded yet';

    emit(CartSuccessState(old, busyItemId: item.itemId));
    final result = await CartRepo.updateCart(
      cartItemId: item.itemId,
      quantity: quantity,
    );
    return result.fold<String?>(
      (failure) {
        emit(CartSuccessState(old));
        return failure.message;
      },
      (cart) {
        emit(CartSuccessState(cart));
        return null;
      },
    );
  }

  Future<String?> removeItem(CartItemModel item) async {
    final old = _cart;
    if (old == null) return 'Cart is not loaded yet';

    emit(CartSuccessState(old, busyItemId: item.itemId));
    final result = await CartRepo.removeFromCart(item.itemId);
    return result.fold<String?>(
      (failure) {
        emit(CartSuccessState(old));
        return failure.message;
      },
      (cart) {
        emit(CartSuccessState(cart));
        return null;
      },
    );
  }

  void clear() => emit(CartInitial());
}
