import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_home_event.freezed.dart';

@freezed
sealed class MovieHomeEvent with _$MovieHomeEvent {
  const factory MovieHomeEvent.fetchHomeData() = FetchHomeData;
  const factory MovieHomeEvent.selectCategory(String categorySlug) = SelectCategory;
  const factory MovieHomeEvent.loadMoreNewlyUpdated() = LoadMoreNewlyUpdated;
}
