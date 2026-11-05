import 'package:bloc/bloc.dart';
import 'package:bookia_app/featuers/cart/data/models/cart_model.dart';
import 'package:bookia_app/featuers/cart/data/repo/cart_repo.dart';
import 'package:meta/meta.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  CartModel? get _cart {
    final current = state;
    return current is CartSuccessState ? current.cart : null;
  }

  Future<void> getCart() async {
    if (_cart == null) emit(CartLoadingState());

    final cart = await CartRepo.getCart();
    if (cart != null) {
      emit(CartSuccessState(cart));
    } else if (_cart == null) {
      emit(CartErrorState());
    }
  }

  Future<bool> addToCart(int productId) async {
    final cart = await CartRepo.addToCart(productId);
    if (cart == null) return false;
    emit(CartSuccessState(cart));
    return true;
  }

  Future<bool> increment(CartItemModel item) {
    if (item.stock > 0 && item.quantity >= item.stock) {
      return Future.value(false);
    }
    return _updateQuantity(item, item.quantity + 1);
  }

  Future<bool> decrement(CartItemModel item) {
    if (item.quantity <= 1) return Future.value(false);
    return _updateQuantity(item, item.quantity - 1);
  }

  Future<bool> _updateQuantity(CartItemModel item, int quantity) async {
    final old = _cart;
    if (old == null) return false;

    emit(CartSuccessState(old, busyItemId: item.itemId));
    final cart = await CartRepo.updateCart(
      cartItemId: item.itemId,
      quantity: quantity,
    );
    emit(CartSuccessState(cart ?? old));
    return cart != null;
  }

  Future<bool> removeItem(CartItemModel item) async {
    final old = _cart;
    if (old == null) return false;

    emit(CartSuccessState(old, busyItemId: item.itemId));
    final cart = await CartRepo.removeFromCart(item.itemId);
    emit(CartSuccessState(cart ?? old));
    return cart != null;
  }

  void clear() => emit(CartInitial());
}
