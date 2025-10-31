import 'dart:convert';

class SearchFilter {
  String sortField;
  String sortType;
  String? sortLang;
  String? category;
  String? country;
  int? year;
  String? keyword;

  SearchFilter({
    this.sortField = 'modified.time',
    this.sortType = 'desc',
    this.sortLang,
    this.category,
    this.country,
    this.year,
    this.keyword,
  });

  SearchFilter copyWith({
    String? sortField,
    String? sortType,
    String? sortLang,
    String? category,
    String? country,
    int? year,
    String? keyword,
  }) {
    return SearchFilter(
      sortField: sortField ?? this.sortField,
      sortType: sortType ?? this.sortType,
      sortLang: sortLang ?? this.sortLang,
      category: category ?? this.category,
      country: country ?? this.country,
      year: year ?? this.year,
      keyword: keyword ?? this.keyword,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (keyword != null && keyword!.isNotEmpty) 'keyword': keyword,
      'sort_field': sortField,
      'sort_type': sortType,
      if (sortLang != null) 'sort_lang': sortLang,
      if (category != null) 'category': category,
      if (country != null) 'country': country,
      if (year != null) 'year': year,
    };
  }

  factory SearchFilter.fromMap(Map<String, dynamic> map) {
    return SearchFilter(
      keyword: map['keyword'],
      sortField: map['sort_field'] ?? 'modified.time',
      sortType: map['sort_type'] ?? 'desc',
      sortLang: map['sort_lang'],
      category: map['category'],
      country: map['country'],
      year: map['year'] is int
          ? map['year']
          : (map['year'] != null ? int.tryParse(map['year'].toString()) : null),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory SearchFilter.fromJson(String source) =>
      SearchFilter.fromMap(jsonDecode(source));

  Map<String, String> toQuery() {
    final map = <String, String>{};
    if (keyword != null && keyword!.isNotEmpty) map['keyword'] = keyword!;
    map['sort_field'] = sortField;
    map['sort_type'] = sortType;
    if (sortLang != null) map['sort_lang'] = sortLang!;
    if (category != null) map['category'] = category!;
    if (country != null) map['country'] = country!;
    if (year != null) map['year'] = year!.toString();
    return map;
  }

  String toQueryString() {
    final uri = Uri(queryParameters: toQuery());
    return uri.query;
  }

  @override
  String toString() {
    return 'SearchFilter(sortField: $sortField, sortType: $sortType, sortLang: $sortLang, category: $category, country: $country, year: $year, keyword: $keyword)';
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
