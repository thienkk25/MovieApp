import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetFavoriteMoviesNotifier extends StateNotifier<List> {
  GetFavoriteMoviesNotifier() : super([]);
  initState(List data) {
    state = data;
  }

  addState(Map data) {
    state = [...state, data];
  }

  removeState(String slug) {
    List newData = state;
    newData.removeWhere((element) => element['slug'] == slug);
    state = newData;
  }
}

final getFavoriteMoviesNotifierProvider =
    StateNotifierProvider<GetFavoriteMoviesNotifier, List>(
        (ref) => GetFavoriteMoviesNotifier());
