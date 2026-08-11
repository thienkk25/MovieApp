// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_favorite_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieFavoriteState {
  MovieFavoriteStatus get status;
  List<MovieEntity> get favoriteMovies;
  String? get errorMessage;

  /// Create a copy of MovieFavoriteState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MovieFavoriteStateCopyWith<MovieFavoriteState> get copyWith =>
      _$MovieFavoriteStateCopyWithImpl<MovieFavoriteState>(
          this as MovieFavoriteState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MovieFavoriteState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.favoriteMovies, favoriteMovies) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status,
      const DeepCollectionEquality().hash(favoriteMovies), errorMessage);

  @override
  String toString() {
    return 'MovieFavoriteState(status: $status, favoriteMovies: $favoriteMovies, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $MovieFavoriteStateCopyWith<$Res> {
  factory $MovieFavoriteStateCopyWith(
          MovieFavoriteState value, $Res Function(MovieFavoriteState) _then) =
      _$MovieFavoriteStateCopyWithImpl;
  @useResult
  $Res call(
      {MovieFavoriteStatus status,
      List<MovieEntity> favoriteMovies,
      String? errorMessage});
}

/// @nodoc
class _$MovieFavoriteStateCopyWithImpl<$Res>
    implements $MovieFavoriteStateCopyWith<$Res> {
  _$MovieFavoriteStateCopyWithImpl(this._self, this._then);

  final MovieFavoriteState _self;
  final $Res Function(MovieFavoriteState) _then;

  /// Create a copy of MovieFavoriteState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? favoriteMovies = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MovieFavoriteStatus,
      favoriteMovies: null == favoriteMovies
          ? _self.favoriteMovies
          : favoriteMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MovieFavoriteState].
extension MovieFavoriteStatePatterns on MovieFavoriteState {
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
    TResult Function(_MovieFavoriteState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieFavoriteState() when $default != null:
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
    TResult Function(_MovieFavoriteState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieFavoriteState():
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
    TResult? Function(_MovieFavoriteState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieFavoriteState() when $default != null:
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
    TResult Function(MovieFavoriteStatus status,
            List<MovieEntity> favoriteMovies, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieFavoriteState() when $default != null:
        return $default(_that.status, _that.favoriteMovies, _that.errorMessage);
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
    TResult Function(MovieFavoriteStatus status,
            List<MovieEntity> favoriteMovies, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieFavoriteState():
        return $default(_that.status, _that.favoriteMovies, _that.errorMessage);
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
    TResult? Function(MovieFavoriteStatus status,
            List<MovieEntity> favoriteMovies, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieFavoriteState() when $default != null:
        return $default(_that.status, _that.favoriteMovies, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MovieFavoriteState implements MovieFavoriteState {
  const _MovieFavoriteState(
      {this.status = MovieFavoriteStatus.initial,
      final List<MovieEntity> favoriteMovies = const [],
      this.errorMessage})
      : _favoriteMovies = favoriteMovies;

  @override
  @JsonKey()
  final MovieFavoriteStatus status;
  final List<MovieEntity> _favoriteMovies;
  @override
  @JsonKey()
  List<MovieEntity> get favoriteMovies {
    if (_favoriteMovies is EqualUnmodifiableListView) return _favoriteMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_favoriteMovies);
  }

  @override
  final String? errorMessage;

  /// Create a copy of MovieFavoriteState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MovieFavoriteStateCopyWith<_MovieFavoriteState> get copyWith =>
      __$MovieFavoriteStateCopyWithImpl<_MovieFavoriteState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MovieFavoriteState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._favoriteMovies, _favoriteMovies) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status,
      const DeepCollectionEquality().hash(_favoriteMovies), errorMessage);

  @override
  String toString() {
    return 'MovieFavoriteState(status: $status, favoriteMovies: $favoriteMovies, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$MovieFavoriteStateCopyWith<$Res>
    implements $MovieFavoriteStateCopyWith<$Res> {
  factory _$MovieFavoriteStateCopyWith(
          _MovieFavoriteState value, $Res Function(_MovieFavoriteState) _then) =
      __$MovieFavoriteStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MovieFavoriteStatus status,
      List<MovieEntity> favoriteMovies,
      String? errorMessage});
}

/// @nodoc
class __$MovieFavoriteStateCopyWithImpl<$Res>
    implements _$MovieFavoriteStateCopyWith<$Res> {
  __$MovieFavoriteStateCopyWithImpl(this._self, this._then);

  final _MovieFavoriteState _self;
  final $Res Function(_MovieFavoriteState) _then;

  /// Create a copy of MovieFavoriteState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? favoriteMovies = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_MovieFavoriteState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MovieFavoriteStatus,
      favoriteMovies: null == favoriteMovies
          ? _self._favoriteMovies
          : favoriteMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
