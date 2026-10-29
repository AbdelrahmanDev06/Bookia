import 'package:bloc/bloc.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';
part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit(this.initialProduct) : super(BookDetailsInitial());

  final ProductModel initialProduct;

  getDetails() async {
    emit(BookDetailsLoadingState());
    final product = await HomeRepo.getProductDetails(initialProduct.id);

    if (product != null) {
      emit(BookDetailsSuccessState(product));
    } else {
      emit(BookDetailsErrorState());
    }
  }
}
