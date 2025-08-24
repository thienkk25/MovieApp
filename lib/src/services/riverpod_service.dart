import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkModeProvider = StateProvider<bool>((ref) => false);
final currentTitle = StateProvider<String>((ref) => "Trang chủ");

class GetFavoriteMoviesNotifier extends StateNotifier<List> {
  GetFavoriteMoviesNotifier() : super([]);
  initState(List data) {
    state = data;
  }

  addState(Map data) {
    state = [...state, data];
  }

  removeState(String slug) {
    List newData = [];
    for (var element in state) {
      if (element['slug'] != slug) {
        newData.add(element);
      }
    }
    state = newData;
  }
}

final getFavoriteMoviesNotifierProvider =
    StateNotifierProvider<GetFavoriteMoviesNotifier, List>(
        (ref) => GetFavoriteMoviesNotifier());

class ViewMoreMoviesNotifier extends StateNotifier<List> {
  ViewMoreMoviesNotifier() : super([]);
  initState(List data) {
    state = data;
  }

  addState(List data) {
    List newData = state;
    newData.addAll(data);
    state = newData;
  }
}

final viewMoreMoviesNotifierProvider =
    StateNotifierProvider<ViewMoreMoviesNotifier, List>(
        (ref) => ViewMoreMoviesNotifier());
