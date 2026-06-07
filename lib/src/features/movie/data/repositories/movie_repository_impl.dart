import 'package:movie_app/src/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie_app/src/features/movie/data/datasources/movie_firestore_data_source.dart';
import 'package:movie_app/src/features/movie/data/models/search_filter.dart';
import 'package:movie_app/src/features/movie/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieFirestoreDataSource firestoreDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.firestoreDataSource,
  });

  @override
  Future<List> categoryMovies() async {
    try {
      return await remoteDataSource.categoryMovies();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map> categoryDetailMovies(
    String type,
    int page,
    int limit,
    String sortType,
    String country,
    int year,
  ) async {
    try {
      return await remoteDataSource.categoryDetailMovies(
        type,
        page,
        limit,
        sortType,
        country,
        year,
      );
    } catch (e) {
      return {};
    }
  }

  @override
  Future<List> countryMovies() async {
    try {
      return await remoteDataSource.countryMovies();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map> countryDetailMovies(String country, int page, int limit) async {
    try {
      return await remoteDataSource.countryDetailMovies(country, page, limit);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> yearDetailMovies(String year, int page, int limit) async {
    try {
      return await remoteDataSource.yearDetailMovies(year, page, limit);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> newlyUpdatedMovies(int page) async {
    try {
      return await remoteDataSource.newlyUpdatedMovies(page);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> newlyUpdatedMoviesV3(int page) async {
    try {
      return await remoteDataSource.newlyUpdatedMoviesV3(page);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> searchMovies({
    required String keyword,
    required int limit,
    SearchFilter? filters,
  }) async {
    try {
      return await remoteDataSource.searchMovies(
        keyword: keyword,
        limit: limit,
        filters: filters,
      );
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> dramaMovies(int page, int limit) async {
    try {
      return await remoteDataSource.dramaMovies(page, limit);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> singleMovies(int page, int limit) async {
    try {
      return await remoteDataSource.singleMovies(page, limit);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> cartoonMovies(int page, int limit) async {
    try {
      return await remoteDataSource.cartoonMovies(page, limit);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> tvShowsMovies(int page, int limit) async {
    try {
      return await remoteDataSource.tvShowsMovies(page, limit);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> vietSubMovies(int page, int limit) async {
    try {
      return await remoteDataSource.vietSubMovies(page, limit);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> narratedMovies(int page, int limit) async {
    try {
      return await remoteDataSource.narratedMovies(page, limit);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map> dubbedMovies(int page, int limit) async {
    try {
      return await remoteDataSource.dubbedMovies(page, limit);
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map?> singleDetailMovies(String nameMovie) async {
    try {
      return await remoteDataSource.singleDetailMovies(nameMovie);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Map> getFavoriteMovies() async {
    try {
      return await firestoreDataSource.getFavoriteMovies();
    } catch (e) {
      return {};
    }
  }

  @override
  Future<bool> addFavoriteMovies(
    String name,
    String slug,
    String posterUrl,
    String lang,
    String episodeCurrent,
  ) async {
    try {
      return await firestoreDataSource.addFavoriteMovies(
        name,
        slug,
        posterUrl,
        lang,
        episodeCurrent,
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> removeFavoriteMovie(String slug) async {
    try {
      return await firestoreDataSource.removeFavoriteMovie(slug);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map> historyWatchMovies() async {
    try {
      return await firestoreDataSource.historyWatchMovies();
    } catch (e) {
      return {};
    }
  }

  @override
  Future<Map?> getHistoryWatchMovies(String slug) async {
    try {
      return await firestoreDataSource.getHistoryWatchMovies(slug);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addHistoryWatchMovies(
    String name,
    String slug,
    String posterUrl,
    int episode,
  ) async {
    try {
      await firestoreDataSource.addHistoryWatchMovies(
        name,
        slug,
        posterUrl,
        episode,
      );
    } catch (e) {
      return;
    }
  }

  @override
  Future<bool> removeHistoryWatchMovies(String slug) async {
    try {
      return await firestoreDataSource.removeHistoryWatchMovies(slug);
    } catch (e) {
      return false;
    }
  }
}
