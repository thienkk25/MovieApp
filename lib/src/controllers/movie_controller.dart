import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/services/movie_service.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class MovieController {
  MovieService movieService = MovieService();
  Future<List> categoryMovies() async {
    final data = await movieService.categoryMovies();
    return data;
  }

  Future<Map> categoryDetailMovies(String type, int page, int limit) async {
    final data = movieService.categoryDetailMovies(type, page, limit);
    return data;
  }

  Future<Map> newlyUpdatedMovies({int page = 1}) async {
    final data = await movieService.newlyUpdatedMovies(page);
    return data;
  }

  Future<Map> searchMovies(String keyword, int limit) async {
    final data = await movieService.searchMovies(keyword, limit);
    return data;
  }

  Future<Map> dramaMovies(int page, int limit) async {
    final data = await movieService.dramaMovies(page, limit);
    return data;
  }

  Future<Map> singleMovies(int page, int limit) async {
    final data = await movieService.singleMovies(page, limit);
    return data;
  }

  Future<Map> cartoonMovies(int page, int limit) async {
    final data = await movieService.cartoonMovies(page, limit);
    return data;
  }

  Future<Map> tvShowsMovies(int page, int limit) async {
    final data = await movieService.tvShowsMovies(page, limit);
    return data;
  }

  Future<Map?> singleDetailMovies(String nameMovie, WidgetRef ref) async {
    final data = await movieService.singleDetailMovies(nameMovie);
    ref.read(isClickWatchEpisodeMovies.notifier).state = false;
    return data;
  }

  Future<void> getFavoriteMovies(WidgetRef ref) async {
    final data = await movieService.getFavoriteMovies();
    ref.read(getFavoriteMoviesNotifierProvider.notifier).initState(data);
  }

  Future<bool> addFavoriteMovies(
      String name, String slug, String posterUrl) async {
    final result = await movieService.addFavoriteMovies(name, slug, posterUrl);
    return result;
  }

  Future<bool> removeFavoriteMovie(String slug) async {
    final result = await movieService.removeFavoriteMovie(slug);
    return result;
  }

  Future<void> historyWatchMovies(WidgetRef ref) async {
    final data = await movieService.historyWatchMovies();
    ref.read(historyMoviesNotifierProvider.notifier).initState(data);
  }

  Future<Map?> getHistoryWatchMovies(String slug) async {
    final result = await movieService.getHistoryWatchMovies(slug);
    return result;
  }

  Future<void> addHistoryWatchMovies(
      String name, String slug, String posterUrl, int episode) async {
    await movieService.addHistoryWatchMovies(name, slug, posterUrl, episode);
  }

  Future<bool> removeHistoryWatchMovies(String slug) async {
    final result = await movieService.removeHistoryWatchMovies(slug);
    return result;
  }
}
