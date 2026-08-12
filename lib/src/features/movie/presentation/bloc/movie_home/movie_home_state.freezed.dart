// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieHomeState {
  MovieHomeStatus get status;
  List<MovieEntity> get heroCarousel;
  List<MovieEntity> get newlyUpdatedMovies;
  List<MovieEntity> get singleMovies;
  List<MovieEntity> get dramaMovies;
  List<MovieEntity> get cartoonMovies;
  List<MovieEntity> get tvShowsMovies;
  List<MovieEntity> get categoryMovies;
  String get selectedCategorySlug;
  int get currentPage;
  bool get isCategoryLoading;
  String? get errorMessage;

  /// Create a copy of MovieHomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MovieHomeStateCopyWith<MovieHomeState> get copyWith =>
      _$MovieHomeStateCopyWithImpl<MovieHomeState>(
          this as MovieHomeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MovieHomeState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.heroCarousel, heroCarousel) &&
            const DeepCollectionEquality()
                .equals(other.newlyUpdatedMovies, newlyUpdatedMovies) &&
            const DeepCollectionEquality()
                .equals(other.singleMovies, singleMovies) &&
            const DeepCollectionEquality()
                .equals(other.dramaMovies, dramaMovies) &&
            const DeepCollectionEquality()
                .equals(other.cartoonMovies, cartoonMovies) &&
            const DeepCollectionEquality()
                .equals(other.tvShowsMovies, tvShowsMovies) &&
            const DeepCollectionEquality()
                .equals(other.categoryMovies, categoryMovies) &&
            (identical(other.selectedCategorySlug, selectedCategorySlug) ||
                other.selectedCategorySlug == selectedCategorySlug) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.isCategoryLoading, isCategoryLoading) ||
                other.isCategoryLoading == isCategoryLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(heroCarousel),
      const DeepCollectionEquality().hash(newlyUpdatedMovies),
      const DeepCollectionEquality().hash(singleMovies),
      const DeepCollectionEquality().hash(dramaMovies),
      const DeepCollectionEquality().hash(cartoonMovies),
      const DeepCollectionEquality().hash(tvShowsMovies),
      const DeepCollectionEquality().hash(categoryMovies),
      selectedCategorySlug,
      currentPage,
      isCategoryLoading,
      errorMessage);

  @override
  String toString() {
    return 'MovieHomeState(status: $status, heroCarousel: $heroCarousel, newlyUpdatedMovies: $newlyUpdatedMovies, singleMovies: $singleMovies, dramaMovies: $dramaMovies, cartoonMovies: $cartoonMovies, tvShowsMovies: $tvShowsMovies, categoryMovies: $categoryMovies, selectedCategorySlug: $selectedCategorySlug, currentPage: $currentPage, isCategoryLoading: $isCategoryLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $MovieHomeStateCopyWith<$Res> {
  factory $MovieHomeStateCopyWith(
          MovieHomeState value, $Res Function(MovieHomeState) _then) =
      _$MovieHomeStateCopyWithImpl;
  @useResult
  $Res call(
      {MovieHomeStatus status,
      List<MovieEntity> heroCarousel,
      List<MovieEntity> newlyUpdatedMovies,
      List<MovieEntity> singleMovies,
      List<MovieEntity> dramaMovies,
      List<MovieEntity> cartoonMovies,
      List<MovieEntity> tvShowsMovies,
      List<MovieEntity> categoryMovies,
      String selectedCategorySlug,
      int currentPage,
      bool isCategoryLoading,
      String? errorMessage});
}

/// @nodoc
class _$MovieHomeStateCopyWithImpl<$Res>
    implements $MovieHomeStateCopyWith<$Res> {
  _$MovieHomeStateCopyWithImpl(this._self, this._then);

  final MovieHomeState _self;
  final $Res Function(MovieHomeState) _then;

  /// Create a copy of MovieHomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? heroCarousel = null,
    Object? newlyUpdatedMovies = null,
    Object? singleMovies = null,
    Object? dramaMovies = null,
    Object? cartoonMovies = null,
    Object? tvShowsMovies = null,
    Object? categoryMovies = null,
    Object? selectedCategorySlug = null,
    Object? currentPage = null,
    Object? isCategoryLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MovieHomeStatus,
      heroCarousel: null == heroCarousel
          ? _self.heroCarousel
          : heroCarousel // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      newlyUpdatedMovies: null == newlyUpdatedMovies
          ? _self.newlyUpdatedMovies
          : newlyUpdatedMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      singleMovies: null == singleMovies
          ? _self.singleMovies
          : singleMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      dramaMovies: null == dramaMovies
          ? _self.dramaMovies
          : dramaMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      cartoonMovies: null == cartoonMovies
          ? _self.cartoonMovies
          : cartoonMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      tvShowsMovies: null == tvShowsMovies
          ? _self.tvShowsMovies
          : tvShowsMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      categoryMovies: null == categoryMovies
          ? _self.categoryMovies
          : categoryMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      selectedCategorySlug: null == selectedCategorySlug
          ? _self.selectedCategorySlug
          : selectedCategorySlug // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      isCategoryLoading: null == isCategoryLoading
          ? _self.isCategoryLoading
          : isCategoryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MovieHomeState].
extension MovieHomeStatePatterns on MovieHomeState {
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
    TResult Function(_MovieHomeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieHomeState() when $default != null:
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
    TResult Function(_MovieHomeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieHomeState():
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
    TResult? Function(_MovieHomeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieHomeState() when $default != null:
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
            MovieHomeStatus status,
            List<MovieEntity> heroCarousel,
            List<MovieEntity> newlyUpdatedMovies,
            List<MovieEntity> singleMovies,
            List<MovieEntity> dramaMovies,
            List<MovieEntity> cartoonMovies,
            List<MovieEntity> tvShowsMovies,
            List<MovieEntity> categoryMovies,
            String selectedCategorySlug,
            int currentPage,
            bool isCategoryLoading,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieHomeState() when $default != null:
        return $default(
            _that.status,
            _that.heroCarousel,
            _that.newlyUpdatedMovies,
            _that.singleMovies,
            _that.dramaMovies,
            _that.cartoonMovies,
            _that.tvShowsMovies,
            _that.categoryMovies,
            _that.selectedCategorySlug,
            _that.currentPage,
            _that.isCategoryLoading,
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
            MovieHomeStatus status,
            List<MovieEntity> heroCarousel,
            List<MovieEntity> newlyUpdatedMovies,
            List<MovieEntity> singleMovies,
            List<MovieEntity> dramaMovies,
            List<MovieEntity> cartoonMovies,
            List<MovieEntity> tvShowsMovies,
            List<MovieEntity> categoryMovies,
            String selectedCategorySlug,
            int currentPage,
            bool isCategoryLoading,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieHomeState():
        return $default(
            _that.status,
            _that.heroCarousel,
            _that.newlyUpdatedMovies,
            _that.singleMovies,
            _that.dramaMovies,
            _that.cartoonMovies,
            _that.tvShowsMovies,
            _that.categoryMovies,
            _that.selectedCategorySlug,
            _that.currentPage,
            _that.isCategoryLoading,
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
            MovieHomeStatus status,
            List<MovieEntity> heroCarousel,
            List<MovieEntity> newlyUpdatedMovies,
            List<MovieEntity> singleMovies,
            List<MovieEntity> dramaMovies,
            List<MovieEntity> cartoonMovies,
            List<MovieEntity> tvShowsMovies,
            List<MovieEntity> categoryMovies,
            String selectedCategorySlug,
            int currentPage,
            bool isCategoryLoading,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieHomeState() when $default != null:
        return $default(
            _that.status,
            _that.heroCarousel,
            _that.newlyUpdatedMovies,
            _that.singleMovies,
            _that.dramaMovies,
            _that.cartoonMovies,
            _that.tvShowsMovies,
            _that.categoryMovies,
            _that.selectedCategorySlug,
            _that.currentPage,
            _that.isCategoryLoading,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _MovieHomeState implements MovieHomeState {
  const _MovieHomeState(
      {this.status = MovieHomeStatus.initial,
      final List<MovieEntity> heroCarousel = const [],
      final List<MovieEntity> newlyUpdatedMovies = const [],
      final List<MovieEntity> singleMovies = const [],
      final List<MovieEntity> dramaMovies = const [],
      final List<MovieEntity> cartoonMovies = const [],
      final List<MovieEntity> tvShowsMovies = const [],
      final List<MovieEntity> categoryMovies = const [],
      this.selectedCategorySlug = 'hanh-dong',
      this.currentPage = 1,
      this.isCategoryLoading = false,
      this.errorMessage})
      : _heroCarousel = heroCarousel,
        _newlyUpdatedMovies = newlyUpdatedMovies,
        _singleMovies = singleMovies,
        _dramaMovies = dramaMovies,
        _cartoonMovies = cartoonMovies,
        _tvShowsMovies = tvShowsMovies,
        _categoryMovies = categoryMovies;

  @override
  @JsonKey()
  final MovieHomeStatus status;
  final List<MovieEntity> _heroCarousel;
  @override
  @JsonKey()
  List<MovieEntity> get heroCarousel {
    if (_heroCarousel is EqualUnmodifiableListView) return _heroCarousel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_heroCarousel);
  }

  final List<MovieEntity> _newlyUpdatedMovies;
  @override
  @JsonKey()
  List<MovieEntity> get newlyUpdatedMovies {
    if (_newlyUpdatedMovies is EqualUnmodifiableListView)
      return _newlyUpdatedMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newlyUpdatedMovies);
  }

  final List<MovieEntity> _singleMovies;
  @override
  @JsonKey()
  List<MovieEntity> get singleMovies {
    if (_singleMovies is EqualUnmodifiableListView) return _singleMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_singleMovies);
  }

  final List<MovieEntity> _dramaMovies;
  @override
  @JsonKey()
  List<MovieEntity> get dramaMovies {
    if (_dramaMovies is EqualUnmodifiableListView) return _dramaMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dramaMovies);
  }

  final List<MovieEntity> _cartoonMovies;
  @override
  @JsonKey()
  List<MovieEntity> get cartoonMovies {
    if (_cartoonMovies is EqualUnmodifiableListView) return _cartoonMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cartoonMovies);
  }

  final List<MovieEntity> _tvShowsMovies;
  @override
  @JsonKey()
  List<MovieEntity> get tvShowsMovies {
    if (_tvShowsMovies is EqualUnmodifiableListView) return _tvShowsMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tvShowsMovies);
  }

  final List<MovieEntity> _categoryMovies;
  @override
  @JsonKey()
  List<MovieEntity> get categoryMovies {
    if (_categoryMovies is EqualUnmodifiableListView) return _categoryMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryMovies);
  }

  @override
  @JsonKey()
  final String selectedCategorySlug;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool isCategoryLoading;
  @override
  final String? errorMessage;

  /// Create a copy of MovieHomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MovieHomeStateCopyWith<_MovieHomeState> get copyWith =>
      __$MovieHomeStateCopyWithImpl<_MovieHomeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MovieHomeState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._heroCarousel, _heroCarousel) &&
            const DeepCollectionEquality()
                .equals(other._newlyUpdatedMovies, _newlyUpdatedMovies) &&
            const DeepCollectionEquality()
                .equals(other._singleMovies, _singleMovies) &&
            const DeepCollectionEquality()
                .equals(other._dramaMovies, _dramaMovies) &&
            const DeepCollectionEquality()
                .equals(other._cartoonMovies, _cartoonMovies) &&
            const DeepCollectionEquality()
                .equals(other._tvShowsMovies, _tvShowsMovies) &&
            const DeepCollectionEquality()
                .equals(other._categoryMovies, _categoryMovies) &&
            (identical(other.selectedCategorySlug, selectedCategorySlug) ||
                other.selectedCategorySlug == selectedCategorySlug) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.isCategoryLoading, isCategoryLoading) ||
                other.isCategoryLoading == isCategoryLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_heroCarousel),
      const DeepCollectionEquality().hash(_newlyUpdatedMovies),
      const DeepCollectionEquality().hash(_singleMovies),
      const DeepCollectionEquality().hash(_dramaMovies),
      const DeepCollectionEquality().hash(_cartoonMovies),
      const DeepCollectionEquality().hash(_tvShowsMovies),
      const DeepCollectionEquality().hash(_categoryMovies),
      selectedCategorySlug,
      currentPage,
      isCategoryLoading,
      errorMessage);

  @override
  String toString() {
    return 'MovieHomeState(status: $status, heroCarousel: $heroCarousel, newlyUpdatedMovies: $newlyUpdatedMovies, singleMovies: $singleMovies, dramaMovies: $dramaMovies, cartoonMovies: $cartoonMovies, tvShowsMovies: $tvShowsMovies, categoryMovies: $categoryMovies, selectedCategorySlug: $selectedCategorySlug, currentPage: $currentPage, isCategoryLoading: $isCategoryLoading, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$MovieHomeStateCopyWith<$Res>
    implements $MovieHomeStateCopyWith<$Res> {
  factory _$MovieHomeStateCopyWith(
          _MovieHomeState value, $Res Function(_MovieHomeState) _then) =
      __$MovieHomeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MovieHomeStatus status,
      List<MovieEntity> heroCarousel,
      List<MovieEntity> newlyUpdatedMovies,
      List<MovieEntity> singleMovies,
      List<MovieEntity> dramaMovies,
      List<MovieEntity> cartoonMovies,
      List<MovieEntity> tvShowsMovies,
      List<MovieEntity> categoryMovies,
      String selectedCategorySlug,
      int currentPage,
      bool isCategoryLoading,
      String? errorMessage});
}

/// @nodoc
class __$MovieHomeStateCopyWithImpl<$Res>
    implements _$MovieHomeStateCopyWith<$Res> {
  __$MovieHomeStateCopyWithImpl(this._self, this._then);

  final _MovieHomeState _self;
  final $Res Function(_MovieHomeState) _then;

  /// Create a copy of MovieHomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? heroCarousel = null,
    Object? newlyUpdatedMovies = null,
    Object? singleMovies = null,
    Object? dramaMovies = null,
    Object? cartoonMovies = null,
    Object? tvShowsMovies = null,
    Object? categoryMovies = null,
    Object? selectedCategorySlug = null,
    Object? currentPage = null,
    Object? isCategoryLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_MovieHomeState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as MovieHomeStatus,
      heroCarousel: null == heroCarousel
          ? _self._heroCarousel
          : heroCarousel // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      newlyUpdatedMovies: null == newlyUpdatedMovies
          ? _self._newlyUpdatedMovies
          : newlyUpdatedMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      singleMovies: null == singleMovies
          ? _self._singleMovies
          : singleMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      dramaMovies: null == dramaMovies
          ? _self._dramaMovies
          : dramaMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      cartoonMovies: null == cartoonMovies
          ? _self._cartoonMovies
          : cartoonMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      tvShowsMovies: null == tvShowsMovies
          ? _self._tvShowsMovies
          : tvShowsMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      categoryMovies: null == categoryMovies
          ? _self._categoryMovies
          : categoryMovies // ignore: cast_nullable_to_non_nullable
              as List<MovieEntity>,
      selectedCategorySlug: null == selectedCategorySlug
          ? _self.selectedCategorySlug
          : selectedCategorySlug // ignore: cast_nullable_to_non_nullable
              as String,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      isCategoryLoading: null == isCategoryLoading
          ? _self.isCategoryLoading
          : isCategoryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
