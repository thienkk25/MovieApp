import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_filter.freezed.dart';
part 'search_filter.g.dart';

@freezed
abstract class SearchFilter with _$SearchFilter {
  const SearchFilter._();

  const factory SearchFilter({
    @Default('modified.time') @JsonKey(name: 'sort_field') String sortField,
    @Default('desc') @JsonKey(name: 'sort_type') String sortType,
    @JsonKey(name: 'sort_lang') String? sortLang,
    String? category,
    String? country,
    int? year,
    String? keyword,
  }) = _SearchFilter;

  factory SearchFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterFromJson(json);

  Map<String, String> toQuery() {
    final map = <String, String>{};
    if (keyword != null && keyword!.isNotEmpty) map['keyword'] = keyword!;
    map['sort_field'] = sortField;
    map['sort_type'] = sortType;
    if (sortLang != null && sortLang!.isNotEmpty) map['sort_lang'] = sortLang!;
    if (category != null && category!.isNotEmpty) map['category'] = category!;
    if (country != null && country!.isNotEmpty) map['country'] = country!;
    if (year != null) map['year'] = year!.toString();
    return map;
  }

  String toQueryString() {
    final queryMap = toQuery();
    return queryMap.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
  }

  bool get isNotEmpty =>
      sortField != 'modified.time' ||
      sortType != 'desc' ||
      (keyword != null && keyword!.isNotEmpty) ||
      (sortLang != null && sortLang!.isNotEmpty) ||
      (category != null && category!.isNotEmpty) ||
      (country != null && country!.isNotEmpty) ||
      year != null;
}
