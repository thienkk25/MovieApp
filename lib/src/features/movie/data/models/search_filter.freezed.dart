// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchFilter {
  @JsonKey(name: 'sort_field')
  String get sortField;
  @JsonKey(name: 'sort_type')
  String get sortType;
  @JsonKey(name: 'sort_lang')
  String? get sortLang;
  String? get category;
  String? get country;
  int? get year;
  String? get keyword;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchFilterCopyWith<SearchFilter> get copyWith =>
      _$SearchFilterCopyWithImpl<SearchFilter>(
          this as SearchFilter, _$identity);

  /// Serializes this SearchFilter to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchFilter &&
            (identical(other.sortField, sortField) ||
                other.sortField == sortField) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType) &&
            (identical(other.sortLang, sortLang) ||
                other.sortLang == sortLang) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.keyword, keyword) || other.keyword == keyword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sortField, sortType, sortLang,
      category, country, year, keyword);

  @override
  String toString() {
    return 'SearchFilter(sortField: $sortField, sortType: $sortType, sortLang: $sortLang, category: $category, country: $country, year: $year, keyword: $keyword)';
  }
}

/// @nodoc
abstract mixin class $SearchFilterCopyWith<$Res> {
  factory $SearchFilterCopyWith(
          SearchFilter value, $Res Function(SearchFilter) _then) =
      _$SearchFilterCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'sort_field') String sortField,
      @JsonKey(name: 'sort_type') String sortType,
      @JsonKey(name: 'sort_lang') String? sortLang,
      String? category,
      String? country,
      int? year,
      String? keyword});
}

/// @nodoc
class _$SearchFilterCopyWithImpl<$Res> implements $SearchFilterCopyWith<$Res> {
  _$SearchFilterCopyWithImpl(this._self, this._then);

  final SearchFilter _self;
  final $Res Function(SearchFilter) _then;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortField = null,
    Object? sortType = null,
    Object? sortLang = freezed,
    Object? category = freezed,
    Object? country = freezed,
    Object? year = freezed,
    Object? keyword = freezed,
  }) {
    return _then(_self.copyWith(
      sortField: null == sortField
          ? _self.sortField
          : sortField // ignore: cast_nullable_to_non_nullable
              as String,
      sortType: null == sortType
          ? _self.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as String,
      sortLang: freezed == sortLang
          ? _self.sortLang
          : sortLang // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      keyword: freezed == keyword
          ? _self.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SearchFilter].
extension SearchFilterPatterns on SearchFilter {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_SearchFilter value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchFilter() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_SearchFilter value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchFilter():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_SearchFilter value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchFilter() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'sort_field') String sortField,
            @JsonKey(name: 'sort_type') String sortType,
            @JsonKey(name: 'sort_lang') String? sortLang,
            String? category,
            String? country,
            int? year,
            String? keyword)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchFilter() when $default != null:
        return $default(_that.sortField, _that.sortType, _that.sortLang,
            _that.category, _that.country, _that.year, _that.keyword);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'sort_field') String sortField,
            @JsonKey(name: 'sort_type') String sortType,
            @JsonKey(name: 'sort_lang') String? sortLang,
            String? category,
            String? country,
            int? year,
            String? keyword)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchFilter():
        return $default(_that.sortField, _that.sortType, _that.sortLang,
            _that.category, _that.country, _that.year, _that.keyword);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'sort_field') String sortField,
            @JsonKey(name: 'sort_type') String sortType,
            @JsonKey(name: 'sort_lang') String? sortLang,
            String? category,
            String? country,
            int? year,
            String? keyword)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchFilter() when $default != null:
        return $default(_that.sortField, _that.sortType, _that.sortLang,
            _that.category, _that.country, _that.year, _that.keyword);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SearchFilter extends SearchFilter {
  const _SearchFilter(
      {@JsonKey(name: 'sort_field') this.sortField = 'modified.time',
      @JsonKey(name: 'sort_type') this.sortType = 'desc',
      @JsonKey(name: 'sort_lang') this.sortLang,
      this.category,
      this.country,
      this.year,
      this.keyword})
      : super._();
  factory _SearchFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterFromJson(json);

  @override
  @JsonKey(name: 'sort_field')
  final String sortField;
  @override
  @JsonKey(name: 'sort_type')
  final String sortType;
  @override
  @JsonKey(name: 'sort_lang')
  final String? sortLang;
  @override
  final String? category;
  @override
  final String? country;
  @override
  final int? year;
  @override
  final String? keyword;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchFilterCopyWith<_SearchFilter> get copyWith =>
      __$SearchFilterCopyWithImpl<_SearchFilter>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SearchFilterToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchFilter &&
            (identical(other.sortField, sortField) ||
                other.sortField == sortField) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType) &&
            (identical(other.sortLang, sortLang) ||
                other.sortLang == sortLang) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.keyword, keyword) || other.keyword == keyword));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sortField, sortType, sortLang,
      category, country, year, keyword);

  @override
  String toString() {
    return 'SearchFilter(sortField: $sortField, sortType: $sortType, sortLang: $sortLang, category: $category, country: $country, year: $year, keyword: $keyword)';
  }
}

/// @nodoc
abstract mixin class _$SearchFilterCopyWith<$Res>
    implements $SearchFilterCopyWith<$Res> {
  factory _$SearchFilterCopyWith(
          _SearchFilter value, $Res Function(_SearchFilter) _then) =
      __$SearchFilterCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'sort_field') String sortField,
      @JsonKey(name: 'sort_type') String sortType,
      @JsonKey(name: 'sort_lang') String? sortLang,
      String? category,
      String? country,
      int? year,
      String? keyword});
}

/// @nodoc
class __$SearchFilterCopyWithImpl<$Res>
    implements _$SearchFilterCopyWith<$Res> {
  __$SearchFilterCopyWithImpl(this._self, this._then);

  final _SearchFilter _self;
  final $Res Function(_SearchFilter) _then;

  /// Create a copy of SearchFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sortField = null,
    Object? sortType = null,
    Object? sortLang = freezed,
    Object? category = freezed,
    Object? country = freezed,
    Object? year = freezed,
    Object? keyword = freezed,
  }) {
    return _then(_SearchFilter(
      sortField: null == sortField
          ? _self.sortField
          : sortField // ignore: cast_nullable_to_non_nullable
              as String,
      sortType: null == sortType
          ? _self.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as String,
      sortLang: freezed == sortLang
          ? _self.sortLang
          : sortLang // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      keyword: freezed == keyword
          ? _self.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
