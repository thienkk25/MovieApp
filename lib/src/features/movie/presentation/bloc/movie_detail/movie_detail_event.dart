import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail_event.freezed.dart';

@freezed
sealed class MovieDetailEvent with _$MovieDetailEvent {
  const factory MovieDetailEvent.fetchMovieDetail(String slug) = FetchMovieDetail;
  const factory MovieDetailEvent.toggleFavorite() = ToggleFavorite;
  const factory MovieDetailEvent.selectEpisode({
    required int serverIndex,
    required int episodeIndex,
  }) = SelectEpisode;
}
