import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/movie_entity.dart';

part 'movie_favorite_event.freezed.dart';

@freezed
sealed class MovieFavoriteEvent with _$MovieFavoriteEvent {
  const factory MovieFavoriteEvent.fetchFavorites() = FetchFavorites;
  const factory MovieFavoriteEvent.addFavorite(MovieEntity movie) = AddFavorite;
  const factory MovieFavoriteEvent.removeFavorite(String slug) = RemoveFavorite;
}
