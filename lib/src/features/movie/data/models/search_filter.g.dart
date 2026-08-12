// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) =>
    _SearchFilter(
      sortField: json['sort_field'] as String? ?? 'modified.time',
      sortType: json['sort_type'] as String? ?? 'desc',
      sortLang: json['sort_lang'] as String?,
      category: json['category'] as String?,
      country: json['country'] as String?,
      year: (json['year'] as num?)?.toInt(),
      keyword: json['keyword'] as String?,
    );

Map<String, dynamic> _$SearchFilterToJson(_SearchFilter instance) =>
    <String, dynamic>{
      'sort_field': instance.sortField,
      'sort_type': instance.sortType,
      'sort_lang': instance.sortLang,
      'category': instance.category,
      'country': instance.country,
      'year': instance.year,
      'keyword': instance.keyword,
    };
