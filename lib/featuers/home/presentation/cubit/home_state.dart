part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeSuccessState extends HomeState {
  final List<ProductModel> bestSellers;
  final List<ProductModel> products;
  final List<SliderModel> sliders;

  HomeSuccessState({
    required this.bestSellers,
    required this.products,
    required this.sliders,
  });
}

final class HomeErrorState extends HomeState {}
