// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_search_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieSearchEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MovieSearchEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieSearchEvent()';
  }
}

/// @nodoc
class $MovieSearchEventCopyWith<$Res> {
  $MovieSearchEventCopyWith(
      MovieSearchEvent _, $Res Function(MovieSearchEvent) __);
}

/// Adds pattern-matching-related methods to [MovieSearchEvent].
extension MovieSearchEventPatterns on MovieSearchEvent {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(KeywordChanged value)? keywordChanged,
    TResult Function(FilterChanged value)? filterChanged,
    TResult Function(ExecuteSearch value)? executeSearch,
    TResult Function(ResetFilter value)? resetFilter,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case KeywordChanged() when keywordChanged != null:
        return keywordChanged(_that);
      case FilterChanged() when filterChanged != null:
        return filterChanged(_that);
      case ExecuteSearch() when executeSearch != null:
        return executeSearch(_that);
      case ResetFilter() when resetFilter != null:
        return resetFilter(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(KeywordChanged value) keywordChanged,
    required TResult Function(FilterChanged value) filterChanged,
    required TResult Function(ExecuteSearch value) executeSearch,
    required TResult Function(ResetFilter value) resetFilter,
  }) {
    final _that = this;
    switch (_that) {
      case KeywordChanged():
        return keywordChanged(_that);
      case FilterChanged():
        return filterChanged(_that);
      case ExecuteSearch():
        return executeSearch(_that);
      case ResetFilter():
        return resetFilter(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(KeywordChanged value)? keywordChanged,
    TResult? Function(FilterChanged value)? filterChanged,
    TResult? Function(ExecuteSearch value)? executeSearch,
    TResult? Function(ResetFilter value)? resetFilter,
  }) {
    final _that = this;
    switch (_that) {
      case KeywordChanged() when keywordChanged != null:
        return keywordChanged(_that);
      case FilterChanged() when filterChanged != null:
        return filterChanged(_that);
      case ExecuteSearch() when executeSearch != null:
        return executeSearch(_that);
      case ResetFilter() when resetFilter != null:
        return resetFilter(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String keyword)? keywordChanged,
    TResult Function(SearchFilter filter)? filterChanged,
    TResult Function()? executeSearch,
    TResult Function()? resetFilter,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case KeywordChanged() when keywordChanged != null:
        return keywordChanged(_that.keyword);
      case FilterChanged() when filterChanged != null:
        return filterChanged(_that.filter);
      case ExecuteSearch() when executeSearch != null:
        return executeSearch();
      case ResetFilter() when resetFilter != null:
        return resetFilter();
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
  TResult when<TResult extends Object?>({
    required TResult Function(String keyword) keywordChanged,
    required TResult Function(SearchFilter filter) filterChanged,
    required TResult Function() executeSearch,
    required TResult Function() resetFilter,
  }) {
    final _that = this;
    switch (_that) {
      case KeywordChanged():
        return keywordChanged(_that.keyword);
      case FilterChanged():
        return filterChanged(_that.filter);
      case ExecuteSearch():
        return executeSearch();
      case ResetFilter():
        return resetFilter();
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String keyword)? keywordChanged,
    TResult? Function(SearchFilter filter)? filterChanged,
    TResult? Function()? executeSearch,
    TResult? Function()? resetFilter,
  }) {
    final _that = this;
    switch (_that) {
      case KeywordChanged() when keywordChanged != null:
        return keywordChanged(_that.keyword);
      case FilterChanged() when filterChanged != null:
        return filterChanged(_that.filter);
      case ExecuteSearch() when executeSearch != null:
        return executeSearch();
      case ResetFilter() when resetFilter != null:
        return resetFilter();
      case _:
        return null;
    }
  }
}

/// @nodoc

class KeywordChanged implements MovieSearchEvent {
  const KeywordChanged(this.keyword);

  final String keyword;

  /// Create a copy of MovieSearchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KeywordChangedCopyWith<KeywordChanged> get copyWith =>
      _$KeywordChangedCopyWithImpl<KeywordChanged>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KeywordChanged &&
            (identical(other.keyword, keyword) || other.keyword == keyword));
  }

  @override
  int get hashCode => Object.hash(runtimeType, keyword);

  @override
  String toString() {
    return 'MovieSearchEvent.keywordChanged(keyword: $keyword)';
  }
}

/// @nodoc
abstract mixin class $KeywordChangedCopyWith<$Res>
    implements $MovieSearchEventCopyWith<$Res> {
  factory $KeywordChangedCopyWith(
          KeywordChanged value, $Res Function(KeywordChanged) _then) =
      _$KeywordChangedCopyWithImpl;
  @useResult
  $Res call({String keyword});
}

/// @nodoc
class _$KeywordChangedCopyWithImpl<$Res>
    implements $KeywordChangedCopyWith<$Res> {
  _$KeywordChangedCopyWithImpl(this._self, this._then);

  final KeywordChanged _self;
  final $Res Function(KeywordChanged) _then;

  /// Create a copy of MovieSearchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? keyword = null,
  }) {
    return _then(KeywordChanged(
      null == keyword
          ? _self.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class FilterChanged implements MovieSearchEvent {
  const FilterChanged(this.filter);

  final SearchFilter filter;

  /// Create a copy of MovieSearchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FilterChangedCopyWith<FilterChanged> get copyWith =>
      _$FilterChangedCopyWithImpl<FilterChanged>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FilterChanged &&
            (identical(other.filter, filter) || other.filter == filter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filter);

  @override
  String toString() {
    return 'MovieSearchEvent.filterChanged(filter: $filter)';
  }
}

/// @nodoc
abstract mixin class $FilterChangedCopyWith<$Res>
    implements $MovieSearchEventCopyWith<$Res> {
  factory $FilterChangedCopyWith(
          FilterChanged value, $Res Function(FilterChanged) _then) =
      _$FilterChangedCopyWithImpl;
  @useResult
  $Res call({SearchFilter filter});

  $SearchFilterCopyWith<$Res> get filter;
}

/// @nodoc
class _$FilterChangedCopyWithImpl<$Res>
    implements $FilterChangedCopyWith<$Res> {
  _$FilterChangedCopyWithImpl(this._self, this._then);

  final FilterChanged _self;
  final $Res Function(FilterChanged) _then;

  /// Create a copy of MovieSearchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? filter = null,
  }) {
    return _then(FilterChanged(
      null == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as SearchFilter,
    ));
  }

  /// Create a copy of MovieSearchEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchFilterCopyWith<$Res> get filter {
    return $SearchFilterCopyWith<$Res>(_self.filter, (value) {
      return _then(_self.copyWith(filter: value));
    });
  }
}

/// @nodoc

class ExecuteSearch implements MovieSearchEvent {
  const ExecuteSearch();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ExecuteSearch);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieSearchEvent.executeSearch()';
  }
}

/// @nodoc

class ResetFilter implements MovieSearchEvent {
  const ResetFilter();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ResetFilter);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieSearchEvent.resetFilter()';
  }
}

// dart format on
