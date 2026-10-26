import 'package:bloc/bloc.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/data/models/slider_model.dart';
import 'package:bookia_app/featuers/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  getHomeData() async {
    emit(HomeLoadingState());

    final (bestSellers, products, sliders) = await (
      HomeRepo.getBestSeller(),
      HomeRepo.getProducts(),
      HomeRepo.getSliders(),
    ).wait;

    if (bestSellers != null && products != null) {
      emit(
        HomeSuccessState(
          bestSellers: bestSellers,
          products: products,
          sliders: sliders ?? [],
        ),
      );
    } else {
      emit(HomeErrorState());
    }
  }
}
