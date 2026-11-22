import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/data/repo/home_repo.dart';
import 'package:flutter/foundation.dart';
part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit(this.initialProduct) : super(BookDetailsInitial());

  final ProductModel initialProduct;

  Future<void> getDetails() async {
    emit(BookDetailsLoadingState());
    final result = await HomeRepo.getProductDetails(initialProduct.id);

    result.fold(
      (failure) => emit(BookDetailsErrorState(failure.message)),
      (product) => emit(BookDetailsSuccessState(product)),
    );
  }
}
