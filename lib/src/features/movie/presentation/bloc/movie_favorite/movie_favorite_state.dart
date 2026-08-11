import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';

part 'movie_favorite_state.freezed.dart';

enum MovieFavoriteStatus { initial, loading, success, failure }

@freezed
abstract class MovieFavoriteState with _$MovieFavoriteState {
  const factory MovieFavoriteState({
    @Default(MovieFavoriteStatus.initial) MovieFavoriteStatus status,
    @Default([]) List<MovieEntity> favoriteMovies,
    String? errorMessage,
  }) = _MovieFavoriteState;
}
