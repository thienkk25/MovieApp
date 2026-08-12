// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_detail_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieDetailEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MovieDetailEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieDetailEvent()';
  }
}

/// @nodoc
class $MovieDetailEventCopyWith<$Res> {
  $MovieDetailEventCopyWith(
      MovieDetailEvent _, $Res Function(MovieDetailEvent) __);
}

/// Adds pattern-matching-related methods to [MovieDetailEvent].
extension MovieDetailEventPatterns on MovieDetailEvent {
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
    TResult Function(FetchMovieDetail value)? fetchMovieDetail,
    TResult Function(ToggleFavorite value)? toggleFavorite,
    TResult Function(SelectEpisode value)? selectEpisode,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FetchMovieDetail() when fetchMovieDetail != null:
        return fetchMovieDetail(_that);
      case ToggleFavorite() when toggleFavorite != null:
        return toggleFavorite(_that);
      case SelectEpisode() when selectEpisode != null:
        return selectEpisode(_that);
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
    required TResult Function(FetchMovieDetail value) fetchMovieDetail,
    required TResult Function(ToggleFavorite value) toggleFavorite,
    required TResult Function(SelectEpisode value) selectEpisode,
  }) {
    final _that = this;
    switch (_that) {
      case FetchMovieDetail():
        return fetchMovieDetail(_that);
      case ToggleFavorite():
        return toggleFavorite(_that);
      case SelectEpisode():
        return selectEpisode(_that);
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
    TResult? Function(FetchMovieDetail value)? fetchMovieDetail,
    TResult? Function(ToggleFavorite value)? toggleFavorite,
    TResult? Function(SelectEpisode value)? selectEpisode,
  }) {
    final _that = this;
    switch (_that) {
      case FetchMovieDetail() when fetchMovieDetail != null:
        return fetchMovieDetail(_that);
      case ToggleFavorite() when toggleFavorite != null:
        return toggleFavorite(_that);
      case SelectEpisode() when selectEpisode != null:
        return selectEpisode(_that);
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
    TResult Function(String slug)? fetchMovieDetail,
    TResult Function()? toggleFavorite,
    TResult Function(int serverIndex, int episodeIndex)? selectEpisode,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FetchMovieDetail() when fetchMovieDetail != null:
        return fetchMovieDetail(_that.slug);
      case ToggleFavorite() when toggleFavorite != null:
        return toggleFavorite();
      case SelectEpisode() when selectEpisode != null:
        return selectEpisode(_that.serverIndex, _that.episodeIndex);
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
    required TResult Function(String slug) fetchMovieDetail,
    required TResult Function() toggleFavorite,
    required TResult Function(int serverIndex, int episodeIndex) selectEpisode,
  }) {
    final _that = this;
    switch (_that) {
      case FetchMovieDetail():
        return fetchMovieDetail(_that.slug);
      case ToggleFavorite():
        return toggleFavorite();
      case SelectEpisode():
        return selectEpisode(_that.serverIndex, _that.episodeIndex);
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
    TResult? Function(String slug)? fetchMovieDetail,
    TResult? Function()? toggleFavorite,
    TResult? Function(int serverIndex, int episodeIndex)? selectEpisode,
  }) {
    final _that = this;
    switch (_that) {
      case FetchMovieDetail() when fetchMovieDetail != null:
        return fetchMovieDetail(_that.slug);
      case ToggleFavorite() when toggleFavorite != null:
        return toggleFavorite();
      case SelectEpisode() when selectEpisode != null:
        return selectEpisode(_that.serverIndex, _that.episodeIndex);
      case _:
        return null;
    }
  }
}

/// @nodoc

class FetchMovieDetail implements MovieDetailEvent {
  const FetchMovieDetail(this.slug);

  final String slug;

  /// Create a copy of MovieDetailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FetchMovieDetailCopyWith<FetchMovieDetail> get copyWith =>
      _$FetchMovieDetailCopyWithImpl<FetchMovieDetail>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FetchMovieDetail &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @override
  int get hashCode => Object.hash(runtimeType, slug);

  @override
  String toString() {
    return 'MovieDetailEvent.fetchMovieDetail(slug: $slug)';
  }
}

/// @nodoc
abstract mixin class $FetchMovieDetailCopyWith<$Res>
    implements $MovieDetailEventCopyWith<$Res> {
  factory $FetchMovieDetailCopyWith(
          FetchMovieDetail value, $Res Function(FetchMovieDetail) _then) =
      _$FetchMovieDetailCopyWithImpl;
  @useResult
  $Res call({String slug});
}

/// @nodoc
class _$FetchMovieDetailCopyWithImpl<$Res>
    implements $FetchMovieDetailCopyWith<$Res> {
  _$FetchMovieDetailCopyWithImpl(this._self, this._then);

  final FetchMovieDetail _self;
  final $Res Function(FetchMovieDetail) _then;

  /// Create a copy of MovieDetailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? slug = null,
  }) {
    return _then(FetchMovieDetail(
      null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class ToggleFavorite implements MovieDetailEvent {
  const ToggleFavorite();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ToggleFavorite);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieDetailEvent.toggleFavorite()';
  }
}

/// @nodoc

class SelectEpisode implements MovieDetailEvent {
  const SelectEpisode({required this.serverIndex, required this.episodeIndex});

  final int serverIndex;
  final int episodeIndex;

  /// Create a copy of MovieDetailEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SelectEpisodeCopyWith<SelectEpisode> get copyWith =>
      _$SelectEpisodeCopyWithImpl<SelectEpisode>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SelectEpisode &&
            (identical(other.serverIndex, serverIndex) ||
                other.serverIndex == serverIndex) &&
            (identical(other.episodeIndex, episodeIndex) ||
                other.episodeIndex == episodeIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, serverIndex, episodeIndex);

  @override
  String toString() {
    return 'MovieDetailEvent.selectEpisode(serverIndex: $serverIndex, episodeIndex: $episodeIndex)';
  }
}

/// @nodoc
abstract mixin class $SelectEpisodeCopyWith<$Res>
    implements $MovieDetailEventCopyWith<$Res> {
  factory $SelectEpisodeCopyWith(
          SelectEpisode value, $Res Function(SelectEpisode) _then) =
      _$SelectEpisodeCopyWithImpl;
  @useResult
  $Res call({int serverIndex, int episodeIndex});
}

/// @nodoc
class _$SelectEpisodeCopyWithImpl<$Res>
    implements $SelectEpisodeCopyWith<$Res> {
  _$SelectEpisodeCopyWithImpl(this._self, this._then);

  final SelectEpisode _self;
  final $Res Function(SelectEpisode) _then;

  /// Create a copy of MovieDetailEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? serverIndex = null,
    Object? episodeIndex = null,
  }) {
    return _then(SelectEpisode(
      serverIndex: null == serverIndex
          ? _self.serverIndex
          : serverIndex // ignore: cast_nullable_to_non_nullable
              as int,
      episodeIndex: null == episodeIndex
          ? _self.episodeIndex
          : episodeIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
