import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/search_filter.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<MovieEntity>>> getNewlyUpdatedMovies(int page);
  Future<Either<Failure, MovieDetailEntity>> getMovieDetail(String slug);
  Future<Either<Failure, List<MovieEntity>>> searchMovies({
    required String keyword,
    required int limit,
    SearchFilter? filters,
  });
  Future<Either<Failure, List<MovieEntity>>> getCategoryMovies({
    required String type,
    int page = 1,
    int limit = 20,
    String sortType = 'desc',
    String country = '',
    int year = 0,
  });
  Future<Either<Failure, Map<String, dynamic>>> getCategories();
  Future<Either<Failure, List<MovieEntity>>> getFavoriteMovies();
  Future<Either<Failure, void>> addFavoriteMovie(MovieEntity movie);
  Future<Either<Failure, void>> removeFavoriteMovie(String slug);
}
