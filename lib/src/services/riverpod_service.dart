import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkModeProvider = StateProvider<bool>((ref) => false);
final currentTitle = StateProvider<String>((ref) => "Trang chủ");
final isLoadingMore = StateProvider<bool>((ref) => false);
final movieDetailOpenCount = StateProvider<int>((ref) => 0);

class GetFavoriteMoviesNotifier extends StateNotifier<List> {
  GetFavoriteMoviesNotifier() : super([]);
  initState(List data) {
    state = [...data];
  }

  addState(Map data) {
    state = [...state, data];
  }

  removeState(String slug) {
    state = state.where((element) => element['slug'] != slug).toList();
  }
}

final getFavoriteMoviesNotifierProvider =
    StateNotifierProvider<GetFavoriteMoviesNotifier, List>(
        (ref) => GetFavoriteMoviesNotifier());

class ViewMoreMoviesNotifier extends StateNotifier<List> {
  ViewMoreMoviesNotifier() : super([]);

  void initState(List data) {
    state = [...data];
  }

  void addState(List data) {
    state = [...state, ...data];
  }
}

final viewMoreMoviesNotifierProvider =
    StateNotifierProvider<ViewMoreMoviesNotifier, List>(
        (ref) => ViewMoreMoviesNotifier());
