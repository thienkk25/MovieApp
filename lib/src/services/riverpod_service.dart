import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final currentTitle = StateProvider<String>((ref) => "Trang chủ");
final isLoadingMore = StateProvider<bool>((ref) => false);
final wasWatchEpisodeMovies = StateProvider<int?>((ref) => null);

class GetFavoriteMoviesNotifier extends StateNotifier<List> {
  GetFavoriteMoviesNotifier() : super([]);
  initState(List data) {
    state = [...data];
  }

  addState(Map data) {
    state = [data, ...state];
  }

  removeState(String slug) {
    state = [...state]..removeWhere((element) => element['slug'] == slug);
  }
}

final getFavoriteMoviesNotifierProvider =
    StateNotifierProvider<GetFavoriteMoviesNotifier, List>(
        (ref) => GetFavoriteMoviesNotifier());

class HistoryMoviesNotifier extends StateNotifier<List> {
  HistoryMoviesNotifier() : super([]);
  initState(List data) {
    state = [...data];
  }

  addState(Map data) {
    state = [data, ...state];
  }

  removeState(String slug) {
    state = [...state]..removeWhere((element) => element['slug'] == slug);
  }
}

final historyMoviesNotifierProvider =
    StateNotifierProvider<HistoryMoviesNotifier, List>(
        (ref) => HistoryMoviesNotifier());

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
