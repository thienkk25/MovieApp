import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';

part 'movie_detail_state.freezed.dart';

enum MovieDetailStatus { initial, loading, success, failure }

@freezed
abstract class MovieDetailState with _$MovieDetailState {
  const factory MovieDetailState({
    @Default(MovieDetailStatus.initial) MovieDetailStatus status,
    MovieDetailEntity? movieDetail,
    @Default([]) List<MovieEntity> relatedMovies,
    @Default(false) bool isFavorite,
    @Default(0) int selectedServerIndex,
    @Default(0) int selectedEpisodeIndex,
    String? errorMessage,
  }) = _MovieDetailState;
}
