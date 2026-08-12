import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/search_filter.dart';

part 'movie_search_event.freezed.dart';

@freezed
sealed class MovieSearchEvent with _$MovieSearchEvent {
  const factory MovieSearchEvent.keywordChanged(String keyword) = KeywordChanged;
  const factory MovieSearchEvent.filterChanged(SearchFilter filter) = FilterChanged;
  const factory MovieSearchEvent.executeSearch() = ExecuteSearch;
  const factory MovieSearchEvent.resetFilter() = ResetFilter;
}
