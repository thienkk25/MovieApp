import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/models/search_filter.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class NewlyUpdatedParams extends Equatable {
  final int page;
  const NewlyUpdatedParams({required this.page});
  @override
  List<Object?> get props => [page];
}

class MovieDetailParams extends Equatable {
  final String slug;
  const MovieDetailParams({required this.slug});
  @override
  List<Object?> get props => [slug];
}

class SearchMoviesParams extends Equatable {
  final String keyword;
  final int limit;
  final SearchFilter? filters;
  const SearchMoviesParams({
    required this.keyword,
    this.limit = 20,
    this.filters,
  });
  @override
  List<Object?> get props => [keyword, limit, filters];
}

class CategoryMoviesParams extends Equatable {
  final String type;
  final int page;
  final int limit;
  const CategoryMoviesParams({
    required this.type,
    this.page = 1,
    this.limit = 20,
  });
  @override
  List<Object?> get props => [type, page, limit];
}

class GetNewlyUpdatedMoviesUseCase
    implements UseCase<List<MovieEntity>, NewlyUpdatedParams> {
  final MovieRepository repository;
  GetNewlyUpdatedMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(NewlyUpdatedParams params) {
    return repository.getNewlyUpdatedMovies(params.page);
  }
}

class GetMovieDetailUseCase
    implements UseCase<MovieDetailEntity, MovieDetailParams> {
  final MovieRepository repository;
  GetMovieDetailUseCase(this.repository);

  @override
  Future<Either<Failure, MovieDetailEntity>> call(MovieDetailParams params) {
    return repository.getMovieDetail(params.slug);
  }
}

class SearchMoviesUseCase
    implements UseCase<List<MovieEntity>, SearchMoviesParams> {
  final MovieRepository repository;
  SearchMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(SearchMoviesParams params) {
    return repository.searchMovies(
      keyword: params.keyword,
      limit: params.limit,
      filters: params.filters,
    );
  }
}

class GetCategoryMoviesUseCase
    implements UseCase<List<MovieEntity>, CategoryMoviesParams> {
  final MovieRepository repository;
  GetCategoryMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(CategoryMoviesParams params) {
    return repository.getCategoryMovies(
      type: params.type,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetFavoriteMoviesUseCase
    implements UseCase<List<MovieEntity>, NoParams> {
  final MovieRepository repository;
  GetFavoriteMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(NoParams params) {
    return repository.getFavoriteMovies();
  }
}

class AddFavoriteMovieUseCase implements UseCase<void, MovieEntity> {
  final MovieRepository repository;
  AddFavoriteMovieUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MovieEntity movie) {
    return repository.addFavoriteMovie(movie);
  }
}

class RemoveFavoriteMovieUseCase implements UseCase<void, String> {
  final MovieRepository repository;
  RemoveFavoriteMovieUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String slug) {
    return repository.removeFavoriteMovie(slug);
  }
}
