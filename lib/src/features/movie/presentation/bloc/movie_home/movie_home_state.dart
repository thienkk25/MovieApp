import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';

part 'movie_home_state.freezed.dart';

enum MovieHomeStatus { initial, loading, success, failure }

@freezed
abstract class MovieHomeState with _$MovieHomeState {
  const factory MovieHomeState({
    @Default(MovieHomeStatus.initial) MovieHomeStatus status,
    @Default([]) List<MovieEntity> heroCarousel,
    @Default([]) List<MovieEntity> newlyUpdatedMovies,
    @Default([]) List<MovieEntity> singleMovies,
    @Default([]) List<MovieEntity> dramaMovies,
    @Default([]) List<MovieEntity> cartoonMovies,
    @Default([]) List<MovieEntity> tvShowsMovies,
    @Default([]) List<MovieEntity> categoryMovies,
    @Default('hanh-dong') String selectedCategorySlug,
    @Default(1) int currentPage,
    @Default(false) bool isCategoryLoading,
    String? errorMessage,
  }) = _MovieHomeState;
}
