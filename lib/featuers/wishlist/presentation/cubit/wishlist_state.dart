part of 'wishlist_cubit.dart';

@immutable
sealed class WishlistState {}

final class WishlistInitial extends WishlistState {}

final class WishlistLoadingState extends WishlistState {}

final class WishlistSuccessState extends WishlistState {
  final List<ProductModel> products;

  WishlistSuccessState(this.products);
}

final class WishlistErrorState extends WishlistState {}
