// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieSearchState {
  MovieSearchStatus get status;
  String get keyword;
  SearchFilter get filter;
  List<MovieEntity> get searchResults;
  String? get errorMessage;

  /// Create a copy of MovieSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MovieSearchStateCopyWith<MovieSearchState> get copyWith =>
      _$MovieSearchStateCopyWithImpl<MovieSearchState>(
          this as MovieSearchState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MovieSearchState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            const DeepCollectionEquality()
                .equals(other.searchResults, searchResults) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, keyword, filter,
      const DeepCollectionEquality().hash(searchResults), errorMessage);

  @override
  String toString() {
    return 'MovieSearchState(status: $status, keyword: $keyword, filter: $filter, searchResults: $searchResults, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $MovieSearchStateCopyWith<$Res> {
  factory $MovieSearchStateCopyWith(
          MovieSearchState value, $Res Function(MovieSearchState) _then) =
      _$MovieSearchStateCopyWithImpl;
  @useResult
  $Res call(
      {MovieSearchStatus status,
      String keyword,
      SearchFilter filter,
      List<MovieEntity> searchResults,
      String? errorMessage});

  $SearchFilterCopyWith<$Res> get filter;
}

/// @nodoc
class _$MovieSearchStateCopyWithImpl<$Res>
    implements $MovieSearchStateCopyWith<$Res> {
  _$MovieSearchStateCopyWithImpl(this._self, this._then);

  final MovieSearchState _self;
  final $Res Function(MovieSearchState) _then;

  /// Create a copy of MovieSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? keyword = null,
    Object? filter = null,
    Object? searchResults = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MovieSearchStatus,
      keyword: null == keyword
          ? _self.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as SearchFilter,
      searchResults: null == searchResults
          ? _self.searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of MovieSearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchFilterCopyWith<$Res> get filter {
    return $SearchFilterCopyWith<$Res>(_self.filter, (value) {
      return _then(_self.copyWith(filter: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MovieSearchState].
extension MovieSearchStatePatterns on MovieSearchState {
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
    TResult Function(_MovieSearchState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieSearchState() when $default != null:
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
    TResult Function(_MovieSearchState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieSearchState():
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
    TResult? Function(_MovieSearchState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieSearchState() when $default != null:
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
            MovieSearchStatus status,
            String keyword,
            SearchFilter filter,
            List<MovieEntity> searchResults,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieSearchState() when $default != null:
        return $default(_that.status, _that.keyword, _that.filter,
            _that.searchResults, _that.errorMessage);
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
            MovieSearchStatus status,
            String keyword,
            SearchFilter filter,
            List<MovieEntity> searchResults,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieSearchState():
        return $default(_that.status, _that.keyword, _that.filter,
            _that.searchResults, _that.errorMessage);
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
            MovieSearchStatus status,
            String keyword,
            SearchFilter filter,
            List<MovieEntity> searchResults,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieSearchState() when $default != null:
        return $default(_that.status, _that.keyword, _that.filter,
            _that.searchResults, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MovieSearchState implements MovieSearchState {
  const _MovieSearchState(
      {this.status = MovieSearchStatus.initial,
      this.keyword = '',
      this.filter = const SearchFilter(),
      final List<MovieEntity> searchResults = const [],
      this.errorMessage})
      : _searchResults = searchResults;

  @override
  @JsonKey()
  final MovieSearchStatus status;
  @override
  @JsonKey()
  final String keyword;
  @override
  @JsonKey()
  final SearchFilter filter;
  final List<MovieEntity> _searchResults;
  @override
  @JsonKey()
  List<MovieEntity> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  @override
  final String? errorMessage;

  /// Create a copy of MovieSearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MovieSearchStateCopyWith<_MovieSearchState> get copyWith =>
      __$MovieSearchStateCopyWithImpl<_MovieSearchState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MovieSearchState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            const DeepCollectionEquality()
                .equals(other._searchResults, _searchResults) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, keyword, filter,
      const DeepCollectionEquality().hash(_searchResults), errorMessage);

  @override
  String toString() {
    return 'MovieSearchState(status: $status, keyword: $keyword, filter: $filter, searchResults: $searchResults, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$MovieSearchStateCopyWith<$Res>
    implements $MovieSearchStateCopyWith<$Res> {
  factory _$MovieSearchStateCopyWith(
          _MovieSearchState value, $Res Function(_MovieSearchState) _then) =
      __$MovieSearchStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MovieSearchStatus status,
      String keyword,
      SearchFilter filter,
      List<MovieEntity> searchResults,
      String? errorMessage});

  @override
  $SearchFilterCopyWith<$Res> get filter;
}

/// @nodoc
class __$MovieSearchStateCopyWithImpl<$Res>
    implements _$MovieSearchStateCopyWith<$Res> {
  __$MovieSearchStateCopyWithImpl(this._self, this._then);

  final _MovieSearchState _self;
  final $Res Function(_MovieSearchState) _then;

  /// Create a copy of MovieSearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? keyword = null,
    Object? filter = null,
    Object? searchResults = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_MovieSearchState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MovieSearchStatus,
      keyword: null == keyword
          ? _self.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String,
      filter: null == filter
          ? _self.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as SearchFilter,
      searchResults: null == searchResults
          ? _self._searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of MovieSearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchFilterCopyWith<$Res> get filter {
    return $SearchFilterCopyWith<$Res>(_self.filter, (value) {
      return _then(_self.copyWith(filter: value));
    });
  }
}

// dart format on
