import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookia_app/core/errors/failure.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/data/models/slider_model.dart';
import 'package:bookia_app/featuers/home/data/repo/home_repo.dart';
import 'package:flutter/foundation.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> getHomeData() async {
    emit(HomeLoadingState());

    final (bestSellersResult, productsResult, slidersResult) = await (
      HomeRepo.getBestSeller(),
      HomeRepo.getProducts(),
      HomeRepo.getSliders(),
    ).wait;

    // best sellers & products are required, sliders are optional
    final failure = bestSellersResult.fold<Failure?>((f) => f, (_) => null) ??
        productsResult.fold<Failure?>((f) => f, (_) => null);
    if (failure != null) {
      emit(HomeErrorState(failure.message));
      return;
    }

    emit(
      HomeSuccessState(
        bestSellers: bestSellersResult.getOrElse(() => []),
        products: productsResult.getOrElse(() => []),
        sliders: slidersResult.getOrElse(() => []),
      ),
    );
  }
}
