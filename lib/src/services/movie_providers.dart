import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/src/controllers/movie_controller.dart';

final movieControllerProvider = Provider((ref) => MovieController());

final categoryMoviesProvider = FutureProvider<List>((ref) async {
  return ref.watch(movieControllerProvider).categoryMovies();
});

final countryMoviesProvider = FutureProvider<List>((ref) async {
  return ref.watch(movieControllerProvider).countryMovies();
});

final newlyUpdatedMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(movieControllerProvider).newlyUpdatedMoviesV3();
});

final singleMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(movieControllerProvider).singleMovies(1, 12);
});

final dramaMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(movieControllerProvider).dramaMovies(1, 12);
});

final cartoonMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(movieControllerProvider).cartoonMovies(1, 12);
});

final tvShowsMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(movieControllerProvider).tvShowsMovies(1, 12);
});

final vietSubMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(movieControllerProvider).vietSubMovies(1, 12);
});

final narratedMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(movieControllerProvider).narratedMovies(1, 12);
});

final dubbedMoviesProvider = FutureProvider<Map>((ref) async {
  return ref.watch(movieControllerProvider).dubbedMovies(1, 12);
});
