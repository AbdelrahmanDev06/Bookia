part of 'search_cubit.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoadingState extends SearchState {}

final class SearchSuccessState extends SearchState {
  final List<ProductModel> products;

  SearchSuccessState(this.products);
}

final class SearchErrorState extends SearchState {}
