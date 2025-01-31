import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/models/movie_model.dart';
import 'package:movie_app/src/services/movie_service.dart';
import 'package:movie_app/src/services/riverpod_service.dart';

class MovieController {
  MovieService movieService = MovieService();
  Future<List> categoryMovies() async {
    final data = await movieService.categoryMovies();
    return data;
  }

  Future<Map> newlyUpdatedMovies() async {
    final data = await movieService.newlyUpdatedMovies();
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

  Future<MovieModel?> singleDetailMovies(String nameMovie) async {
    final data = await movieService.singleDetailMovies(nameMovie);
    return data;
  }

  Future<void> getFavoriteMovies(WidgetRef ref) async {
    final data = await movieService.getFavoriteMovies();
    ref
        .read(getFavoriteMoviesNotifierProvider.notifier)
        .initState(data?['items'] ?? []);
  }

  Future<List> addFavoriteMovies(
      String name, String slug, String posterUrl) async {
    final result = await movieService.addFavoriteMovies(name, slug, posterUrl);
    return result;
  }

  Future<List> removeFavoriteMovie(String slug) async {
    final result = await movieService.removeFavoriteMovie(slug);
    return result;
  }
}
