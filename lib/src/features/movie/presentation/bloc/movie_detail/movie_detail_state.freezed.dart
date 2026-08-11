// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieDetailState {
  MovieDetailStatus get status;
  MovieDetailEntity? get movieDetail;
  List<MovieEntity> get relatedMovies;
  bool get isFavorite;
  int get selectedServerIndex;
  int get selectedEpisodeIndex;
  String? get errorMessage;

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MovieDetailStateCopyWith<MovieDetailState> get copyWith =>
      _$MovieDetailStateCopyWithImpl<MovieDetailState>(
          this as MovieDetailState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MovieDetailState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.movieDetail, movieDetail) ||
                other.movieDetail == movieDetail) &&
            const DeepCollectionEquality()
                .equals(other.relatedMovies, relatedMovies) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.selectedServerIndex, selectedServerIndex) ||
                other.selectedServerIndex == selectedServerIndex) &&
            (identical(other.selectedEpisodeIndex, selectedEpisodeIndex) ||
                other.selectedEpisodeIndex == selectedEpisodeIndex) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      movieDetail,
      const DeepCollectionEquality().hash(relatedMovies),
      isFavorite,
      selectedServerIndex,
      selectedEpisodeIndex,
      errorMessage);

  @override
  String toString() {
    return 'MovieDetailState(status: $status, movieDetail: $movieDetail, relatedMovies: $relatedMovies, isFavorite: $isFavorite, selectedServerIndex: $selectedServerIndex, selectedEpisodeIndex: $selectedEpisodeIndex, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $MovieDetailStateCopyWith<$Res> {
  factory $MovieDetailStateCopyWith(
          MovieDetailState value, $Res Function(MovieDetailState) _then) =
      _$MovieDetailStateCopyWithImpl;
  @useResult
  $Res call(
      {MovieDetailStatus status,
      MovieDetailEntity? movieDetail,
      List<MovieEntity> relatedMovies,
      bool isFavorite,
      int selectedServerIndex,
      int selectedEpisodeIndex,
      String? errorMessage});
}

/// @nodoc
class _$MovieDetailStateCopyWithImpl<$Res>
    implements $MovieDetailStateCopyWith<$Res> {
  _$MovieDetailStateCopyWithImpl(this._self, this._then);

  final MovieDetailState _self;
  final $Res Function(MovieDetailState) _then;

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? movieDetail = freezed,
    Object? relatedMovies = null,
    Object? isFavorite = null,
    Object? selectedServerIndex = null,
    Object? selectedEpisodeIndex = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MovieDetailStatus,
      movieDetail: freezed == movieDetail
          ? _self.movieDetail
          : movieDetail // ignore: cast_nullable_to_non_nullable
              as MovieDetailEntity?,
      relatedMovies: null == relatedMovies
          ? _self.relatedMovies
          : relatedMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      isFavorite: null == isFavorite
          ? _self.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedServerIndex: null == selectedServerIndex
          ? _self.selectedServerIndex
          : selectedServerIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedEpisodeIndex: null == selectedEpisodeIndex
          ? _self.selectedEpisodeIndex
          : selectedEpisodeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MovieDetailState].
extension MovieDetailStatePatterns on MovieDetailState {
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
    TResult Function(_MovieDetailState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieDetailState() when $default != null:
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
    TResult Function(_MovieDetailState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieDetailState():
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
    TResult? Function(_MovieDetailState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieDetailState() when $default != null:
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
            MovieDetailStatus status,
            MovieDetailEntity? movieDetail,
            List<MovieEntity> relatedMovies,
            bool isFavorite,
            int selectedServerIndex,
            int selectedEpisodeIndex,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieDetailState() when $default != null:
        return $default(
            _that.status,
            _that.movieDetail,
            _that.relatedMovies,
            _that.isFavorite,
            _that.selectedServerIndex,
            _that.selectedEpisodeIndex,
            _that.errorMessage);
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
            MovieDetailStatus status,
            MovieDetailEntity? movieDetail,
            List<MovieEntity> relatedMovies,
            bool isFavorite,
            int selectedServerIndex,
            int selectedEpisodeIndex,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieDetailState():
        return $default(
            _that.status,
            _that.movieDetail,
            _that.relatedMovies,
            _that.isFavorite,
            _that.selectedServerIndex,
            _that.selectedEpisodeIndex,
            _that.errorMessage);
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
            MovieDetailStatus status,
            MovieDetailEntity? movieDetail,
            List<MovieEntity> relatedMovies,
            bool isFavorite,
            int selectedServerIndex,
            int selectedEpisodeIndex,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieDetailState() when $default != null:
        return $default(
            _that.status,
            _that.movieDetail,
            _that.relatedMovies,
            _that.isFavorite,
            _that.selectedServerIndex,
            _that.selectedEpisodeIndex,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MovieDetailState implements MovieDetailState {
  const _MovieDetailState(
      {this.status = MovieDetailStatus.initial,
      this.movieDetail,
      final List<MovieEntity> relatedMovies = const [],
      this.isFavorite = false,
      this.selectedServerIndex = 0,
      this.selectedEpisodeIndex = 0,
      this.errorMessage})
      : _relatedMovies = relatedMovies;

  @override
  @JsonKey()
  final MovieDetailStatus status;
  @override
  final MovieDetailEntity? movieDetail;
  final List<MovieEntity> _relatedMovies;
  @override
  @JsonKey()
  List<MovieEntity> get relatedMovies {
    if (_relatedMovies is EqualUnmodifiableListView) return _relatedMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedMovies);
  }

  @override
  @JsonKey()
  final bool isFavorite;
  @override
  @JsonKey()
  final int selectedServerIndex;
  @override
  @JsonKey()
  final int selectedEpisodeIndex;
  @override
  final String? errorMessage;

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MovieDetailStateCopyWith<_MovieDetailState> get copyWith =>
      __$MovieDetailStateCopyWithImpl<_MovieDetailState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MovieDetailState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.movieDetail, movieDetail) ||
                other.movieDetail == movieDetail) &&
            const DeepCollectionEquality()
                .equals(other._relatedMovies, _relatedMovies) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.selectedServerIndex, selectedServerIndex) ||
                other.selectedServerIndex == selectedServerIndex) &&
            (identical(other.selectedEpisodeIndex, selectedEpisodeIndex) ||
                other.selectedEpisodeIndex == selectedEpisodeIndex) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      movieDetail,
      const DeepCollectionEquality().hash(_relatedMovies),
      isFavorite,
      selectedServerIndex,
      selectedEpisodeIndex,
      errorMessage);

  @override
  String toString() {
    return 'MovieDetailState(status: $status, movieDetail: $movieDetail, relatedMovies: $relatedMovies, isFavorite: $isFavorite, selectedServerIndex: $selectedServerIndex, selectedEpisodeIndex: $selectedEpisodeIndex, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$MovieDetailStateCopyWith<$Res>
    implements $MovieDetailStateCopyWith<$Res> {
  factory _$MovieDetailStateCopyWith(
          _MovieDetailState value, $Res Function(_MovieDetailState) _then) =
      __$MovieDetailStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MovieDetailStatus status,
      MovieDetailEntity? movieDetail,
      List<MovieEntity> relatedMovies,
      bool isFavorite,
      int selectedServerIndex,
      int selectedEpisodeIndex,
      String? errorMessage});
}

/// @nodoc
class __$MovieDetailStateCopyWithImpl<$Res>
    implements _$MovieDetailStateCopyWith<$Res> {
  __$MovieDetailStateCopyWithImpl(this._self, this._then);

  final _MovieDetailState _self;
  final $Res Function(_MovieDetailState) _then;

  /// Create a copy of MovieDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? movieDetail = freezed,
    Object? relatedMovies = null,
    Object? isFavorite = null,
    Object? selectedServerIndex = null,
    Object? selectedEpisodeIndex = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_MovieDetailState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MovieDetailStatus,
      movieDetail: freezed == movieDetail
          ? _self.movieDetail
          : movieDetail // ignore: cast_nullable_to_non_nullable
              as MovieDetailEntity?,
      relatedMovies: null == relatedMovies
          ? _self._relatedMovies
          : relatedMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      isFavorite: null == isFavorite
          ? _self.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedServerIndex: null == selectedServerIndex
          ? _self.selectedServerIndex
          : selectedServerIndex // ignore: cast_nullable_to_non_nullable
              as int,
      selectedEpisodeIndex: null == selectedEpisodeIndex
          ? _self.selectedEpisodeIndex
          : selectedEpisodeIndex // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
