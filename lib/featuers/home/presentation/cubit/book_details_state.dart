part of 'book_details_cubit.dart';

@immutable
sealed class BookDetailsState {}

final class BookDetailsInitial extends BookDetailsState {}

final class BookDetailsLoadingState extends BookDetailsState {}

final class BookDetailsSuccessState extends BookDetailsState {
  final ProductModel product;

  BookDetailsSuccessState(this.product);
}

final class BookDetailsErrorState extends BookDetailsState {}
