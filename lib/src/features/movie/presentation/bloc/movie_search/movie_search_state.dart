import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/src/features/movie/data/models/search_filter.dart';
import 'package:movie_app/src/features/movie/domain/entities/movie_entity.dart';

part 'movie_search_state.freezed.dart';

enum MovieSearchStatus { initial, loading, success, failure }

@freezed
abstract class MovieSearchState with _$MovieSearchState {
  const factory MovieSearchState({
    @Default(MovieSearchStatus.initial) MovieSearchStatus status,
    @Default('') String keyword,
    @Default(SearchFilter()) SearchFilter filter,
    @Default([]) List<MovieEntity> searchResults,
    String? errorMessage,
  }) = _MovieSearchState;
}
