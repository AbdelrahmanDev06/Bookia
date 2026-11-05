import 'package:bloc/bloc.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/wishlist/data/repo/wishlist_repo.dart';
import 'package:meta/meta.dart';
part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistInitial());

  Future<void> getWishlist() async {
    // show the loader only the first time, after that refresh silently
    if (state is! WishlistSuccessState) emit(WishlistLoadingState());

    final products = await WishlistRepo.getWishlist();
    if (products != null) {
      emit(WishlistSuccessState(products));
    } else if (state is! WishlistSuccessState) {
      emit(WishlistErrorState());
    }
  }

  bool isInWishlist(int productId) {
    final current = state;
    return current is WishlistSuccessState &&
        current.products.any((p) => p.id == productId);
  }

  Future<bool> addToWishlist(int productId) async {
    final ok = await WishlistRepo.addToWishlist(productId);
    if (ok) await getWishlist();
    return ok;
  }

  Future<bool> removeFromWishlist(int productId) async {
    final current = state;
    if (current is WishlistSuccessState) {
      emit(
        WishlistSuccessState(
          current.products.where((p) => p.id != productId).toList(),
        ),
      );
    }
    final ok = await WishlistRepo.removeFromWishlist(productId);
    await getWishlist();
    return ok;
  }

  Future<bool> toggle(int productId) => isInWishlist(productId)
      ? removeFromWishlist(productId)
      : addToWishlist(productId);

  void clear() => emit(WishlistInitial());
}
