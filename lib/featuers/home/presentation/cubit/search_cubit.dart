import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/data/repo/home_repo.dart';
import 'package:flutter/foundation.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Timer? _debounce;
  String _lastQuery = '';

  void onQueryChanged(String query) {
    _debounce?.cancel();
    final name = query.trim();
    _lastQuery = name;

    if (name.isEmpty) {
      emit(SearchInitial());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () => search(name));
  }

  Future<void> search(String name) async {
    emit(SearchLoadingState());
    final result = await HomeRepo.searchProducts(name);

    if (name != _lastQuery) return;

    result.fold(
      (failure) => emit(SearchErrorState(failure.message)),
      (products) => emit(SearchSuccessState(products)),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
