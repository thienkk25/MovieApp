import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/models/search_filter.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
final isLanguageProvider =
    StateProvider<Locale>((ref) => const Locale('vi', ''));
final currentTitle = StateProvider<String>((ref) => "");
final isLoadingMore = StateProvider<bool>((ref) => false);
final wasWatchEpisodeMovies = StateProvider<int>((ref) => -1);
final isClickWatchEpisodeMovies = StateProvider<bool>((ref) => false);
final isClickLWatchEpisodeLinkMovies = StateProvider<String?>((ref) => null);
final isCollapsedReadMore = StateProvider<bool>((ref) => true);
final isAutoNextMovie = StateProvider<bool>((ref) => false);
final currentNameUser = StateProvider<String>((ref) => '');

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

final searchFilterProvider =
    StateNotifierProvider<SearchFilterNotifier, SearchFilter>(
  (ref) => SearchFilterNotifier(),
);

class SearchFilterNotifier extends StateNotifier<SearchFilter> {
  SearchFilterNotifier() : super(SearchFilter());

  void setCategory(String? value) => state = state.copyWith(category: value);

  void setCountry(String? value) => state = state.copyWith(country: value);

  void setYear(int? value) => state = state.copyWith(year: value);

  void setSortField(String value) => state = state.copyWith(sortField: value);

  void setSortType(String value) => state = state.copyWith(sortType: value);

  void setSortLang(String? value) => state = state.copyWith(sortLang: value);

  void setKeyword(String? value) => state = state.copyWith(keyword: value);

  void clear() => state = SearchFilter();
}
