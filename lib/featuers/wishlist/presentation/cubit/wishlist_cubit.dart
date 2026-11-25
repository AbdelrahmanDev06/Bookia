import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/wishlist/data/repo/wishlist_repo.dart';
import 'package:flutter/foundation.dart';
part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(WishlistInitial());

  Future<void> getWishlist() async {
    if (state is! WishlistSuccessState) emit(WishlistLoadingState());

    final result = await WishlistRepo.getWishlist();
    result.fold(
      (failure) {
        if (state is! WishlistSuccessState) {
          emit(WishlistErrorState(failure.message));
        }
      },
      (products) => emit(WishlistSuccessState(products)),
    );
  }

  bool isInWishlist(int productId) {
    final current = state;
    return current is WishlistSuccessState &&
        current.products.any((p) => p.id == productId);
  }

  Future<String?> addToWishlist(int productId) async {
    final result = await WishlistRepo.addToWishlist(productId);
    final error = result.fold<String?>((failure) => failure.message, (_) => null);
    if (error == null) await getWishlist();
    return error;
  }

  Future<String?> removeFromWishlist(int productId) async {
    final current = state;
    if (current is WishlistSuccessState) {
      emit(
        WishlistSuccessState(
          current.products.where((p) => p.id != productId).toList(),
        ),
      );
    }
    final result = await WishlistRepo.removeFromWishlist(productId);
    await getWishlist();
    return result.fold<String?>((failure) => failure.message, (_) => null);
  }

  Future<String?> toggle(int productId) => isInWishlist(productId)
      ? removeFromWishlist(productId)
      : addToWishlist(productId);

  void clear() => emit(WishlistInitial());
}
