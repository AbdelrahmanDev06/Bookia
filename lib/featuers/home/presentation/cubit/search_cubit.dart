import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookia_app/featuers/home/data/models/product_model.dart';
import 'package:bookia_app/featuers/home/data/repo/home_repo.dart';
import 'package:meta/meta.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Timer? _debounce;
  String _lastQuery = '';

  onQueryChanged(String query) {
    _debounce?.cancel();
    final name = query.trim();
    _lastQuery = name;

    if (name.isEmpty) {
      emit(SearchInitial());
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () => search(name));
  }

  search(String name) async {
    emit(SearchLoadingState());
    final products = await HomeRepo.searchProducts(name);

    if (name != _lastQuery) return;

    if (products != null) {
      emit(SearchSuccessState(products));
    } else {
      emit(SearchErrorState());
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
