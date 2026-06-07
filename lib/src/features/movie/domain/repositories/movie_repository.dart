import 'package:movie_app/src/features/movie/data/models/search_filter.dart';

abstract class MovieRepository {
  Future<List> categoryMovies();
  Future<Map> categoryDetailMovies(String type, int page, int limit,
      String sortType, String country, int year);
  Future<List> countryMovies();
  Future<Map> countryDetailMovies(String country, int page, int limit);
  Future<Map> yearDetailMovies(String year, int page, int limit);
  Future<Map> newlyUpdatedMovies(int page);
  Future<Map> newlyUpdatedMoviesV3(int page);
  Future<Map> searchMovies({
    required String keyword,
    required int limit,
    SearchFilter? filters,
  });
  Future<Map> dramaMovies(int page, int limit);
  Future<Map> singleMovies(int page, int limit);
  Future<Map> cartoonMovies(int page, int limit);
  Future<Map> tvShowsMovies(int page, int limit);
  Future<Map> vietSubMovies(int page, int limit);
  Future<Map> narratedMovies(int page, int limit);
  Future<Map> dubbedMovies(int page, int limit);
  Future<Map?> singleDetailMovies(String nameMovie);
  Future<Map> getFavoriteMovies();
  Future<bool> addFavoriteMovies(String name, String slug, String posterUrl,
      String lang, String episodeCurrent);
  Future<bool> removeFavoriteMovie(String slug);
  Future<Map> historyWatchMovies();
  Future<Map?> getHistoryWatchMovies(String slug);
  Future<void> addHistoryWatchMovies(
      String name, String slug, String posterUrl, int episode);
  Future<bool> removeHistoryWatchMovies(String slug);
}
