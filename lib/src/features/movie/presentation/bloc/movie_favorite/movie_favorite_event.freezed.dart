// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_favorite_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieFavoriteEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MovieFavoriteEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieFavoriteEvent()';
  }
}

/// @nodoc
class $MovieFavoriteEventCopyWith<$Res> {
  $MovieFavoriteEventCopyWith(
      MovieFavoriteEvent _, $Res Function(MovieFavoriteEvent) __);
}

/// Adds pattern-matching-related methods to [MovieFavoriteEvent].
extension MovieFavoriteEventPatterns on MovieFavoriteEvent {
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
    TResult Function(FetchFavorites value)? fetchFavorites,
    TResult Function(AddFavorite value)? addFavorite,
    TResult Function(RemoveFavorite value)? removeFavorite,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FetchFavorites() when fetchFavorites != null:
        return fetchFavorites(_that);
      case AddFavorite() when addFavorite != null:
        return addFavorite(_that);
      case RemoveFavorite() when removeFavorite != null:
        return removeFavorite(_that);
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
    required TResult Function(FetchFavorites value) fetchFavorites,
    required TResult Function(AddFavorite value) addFavorite,
    required TResult Function(RemoveFavorite value) removeFavorite,
  }) {
    final _that = this;
    switch (_that) {
      case FetchFavorites():
        return fetchFavorites(_that);
      case AddFavorite():
        return addFavorite(_that);
      case RemoveFavorite():
        return removeFavorite(_that);
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
    TResult? Function(FetchFavorites value)? fetchFavorites,
    TResult? Function(AddFavorite value)? addFavorite,
    TResult? Function(RemoveFavorite value)? removeFavorite,
  }) {
    final _that = this;
    switch (_that) {
      case FetchFavorites() when fetchFavorites != null:
        return fetchFavorites(_that);
      case AddFavorite() when addFavorite != null:
        return addFavorite(_that);
      case RemoveFavorite() when removeFavorite != null:
        return removeFavorite(_that);
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
    TResult Function()? fetchFavorites,
    TResult Function(MovieEntity movie)? addFavorite,
    TResult Function(String slug)? removeFavorite,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FetchFavorites() when fetchFavorites != null:
        return fetchFavorites();
      case AddFavorite() when addFavorite != null:
        return addFavorite(_that.movie);
      case RemoveFavorite() when removeFavorite != null:
        return removeFavorite(_that.slug);
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
    required TResult Function() fetchFavorites,
    required TResult Function(MovieEntity movie) addFavorite,
    required TResult Function(String slug) removeFavorite,
  }) {
    final _that = this;
    switch (_that) {
      case FetchFavorites():
        return fetchFavorites();
      case AddFavorite():
        return addFavorite(_that.movie);
      case RemoveFavorite():
        return removeFavorite(_that.slug);
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
    TResult? Function()? fetchFavorites,
    TResult? Function(MovieEntity movie)? addFavorite,
    TResult? Function(String slug)? removeFavorite,
  }) {
    final _that = this;
    switch (_that) {
      case FetchFavorites() when fetchFavorites != null:
        return fetchFavorites();
      case AddFavorite() when addFavorite != null:
        return addFavorite(_that.movie);
      case RemoveFavorite() when removeFavorite != null:
        return removeFavorite(_that.slug);
      case _:
        return null;
    }
  }
}

/// @nodoc

class FetchFavorites implements MovieFavoriteEvent {
  const FetchFavorites();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FetchFavorites);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieFavoriteEvent.fetchFavorites()';
  }
}

/// @nodoc

class AddFavorite implements MovieFavoriteEvent {
  const AddFavorite(this.movie);

  final MovieEntity movie;

  /// Create a copy of MovieFavoriteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddFavoriteCopyWith<AddFavorite> get copyWith =>
      _$AddFavoriteCopyWithImpl<AddFavorite>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddFavorite &&
            const DeepCollectionEquality().equals(other.movie, movie));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(movie));

  @override
  String toString() {
    return 'MovieFavoriteEvent.addFavorite(movie: $movie)';
  }
}

/// @nodoc
abstract mixin class $AddFavoriteCopyWith<$Res>
    implements $MovieFavoriteEventCopyWith<$Res> {
  factory $AddFavoriteCopyWith(
          AddFavorite value, $Res Function(AddFavorite) _then) =
      _$AddFavoriteCopyWithImpl;
  @useResult
  $Res call({MovieEntity movie});
}

/// @nodoc
class _$AddFavoriteCopyWithImpl<$Res> implements $AddFavoriteCopyWith<$Res> {
  _$AddFavoriteCopyWithImpl(this._self, this._then);

  final AddFavorite _self;
  final $Res Function(AddFavorite) _then;

  /// Create a copy of MovieFavoriteEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? movie = freezed,
  }) {
    return _then(AddFavorite(
      freezed == movie
          ? _self.movie
          : movie // ignore: cast_nullable_to_non_nullable
              as MovieEntity,
    ));
  }
}

/// @nodoc

class RemoveFavorite implements MovieFavoriteEvent {
  const RemoveFavorite(this.slug);

  final String slug;

  /// Create a copy of MovieFavoriteEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RemoveFavoriteCopyWith<RemoveFavorite> get copyWith =>
      _$RemoveFavoriteCopyWithImpl<RemoveFavorite>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RemoveFavorite &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @override
  int get hashCode => Object.hash(runtimeType, slug);

  @override
  String toString() {
    return 'MovieFavoriteEvent.removeFavorite(slug: $slug)';
  }
}

/// @nodoc
abstract mixin class $RemoveFavoriteCopyWith<$Res>
    implements $MovieFavoriteEventCopyWith<$Res> {
  factory $RemoveFavoriteCopyWith(
          RemoveFavorite value, $Res Function(RemoveFavorite) _then) =
      _$RemoveFavoriteCopyWithImpl;
  @useResult
  $Res call({String slug});
}

/// @nodoc
class _$RemoveFavoriteCopyWithImpl<$Res>
    implements $RemoveFavoriteCopyWith<$Res> {
  _$RemoveFavoriteCopyWithImpl(this._self, this._then);

  final RemoveFavorite _self;
  final $Res Function(RemoveFavorite) _then;

  /// Create a copy of MovieFavoriteEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? slug = null,
  }) {
    return _then(RemoveFavorite(
      null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
