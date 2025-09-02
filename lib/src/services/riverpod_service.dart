import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final isLanguageProvider =
    StateProvider<Locale?>((ref) => const Locale('vi', ''));
final currentTitle = StateProvider<String>((ref) => "");
final isLoadingMore = StateProvider<bool>((ref) => false);
final wasWatchEpisodeMovies = StateProvider<int>((ref) => -1);
final isClickWatchEpisodeMovies = StateProvider<bool>((ref) => false);
final isClickLWatchEpisodeLinkMovies = StateProvider<String?>((ref) => null);

class GetFavoriteMoviesNotifier extends StateNotifier<Map> {
  GetFavoriteMoviesNotifier() : super({});
  initState(Map data) {
    state = data;
  }

  addState(Map data) {
    String slug = data['slug'];
    state = {slug: data, ...state};
  }

  removeState(String slug) {
    final newState = Map.from(state);
    newState.remove(slug);
    state = newState;
  }
}

final getFavoriteMoviesNotifierProvider =
    StateNotifierProvider<GetFavoriteMoviesNotifier, Map>(
        (ref) => GetFavoriteMoviesNotifier());

class HistoryMoviesNotifier extends StateNotifier<Map> {
  HistoryMoviesNotifier() : super({});
  initState(Map data) {
    state = data;
  }

  addState(Map data) {
    String slug = data['slug'];
    state = {slug: data, ...state};
  }

  removeState(String slug) {
    final newState = Map.from(state);
    newState.remove(slug);
    state = newState;
  }
}

final historyMoviesNotifierProvider =
    StateNotifierProvider<HistoryMoviesNotifier, Map>(
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
