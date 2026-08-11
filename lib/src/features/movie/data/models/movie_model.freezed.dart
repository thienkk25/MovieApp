// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieModel {
  dynamic get status;
  @JsonKey(fromJson: _parseStringNullable)
  String? get msg;
  MovieDataModel? get movie;
  List<EpisodeModel>? get episodes;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MovieModelCopyWith<MovieModel> get copyWith =>
      _$MovieModelCopyWithImpl<MovieModel>(this as MovieModel, _$identity);

  /// Serializes this MovieModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MovieModel &&
            const DeepCollectionEquality().equals(other.status, status) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            (identical(other.movie, movie) || other.movie == movie) &&
            const DeepCollectionEquality().equals(other.episodes, episodes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(status),
      msg,
      movie,
      const DeepCollectionEquality().hash(episodes));

  @override
  String toString() {
    return 'MovieModel(status: $status, msg: $msg, movie: $movie, episodes: $episodes)';
  }
}

/// @nodoc
abstract mixin class $MovieModelCopyWith<$Res> {
  factory $MovieModelCopyWith(
          MovieModel value, $Res Function(MovieModel) _then) =
      _$MovieModelCopyWithImpl;
  @useResult
  $Res call(
      {dynamic status,
      @JsonKey(fromJson: _parseStringNullable) String? msg,
      MovieDataModel? movie,
      List<EpisodeModel>? episodes});

  $MovieDataModelCopyWith<$Res>? get movie;
}

/// @nodoc
class _$MovieModelCopyWithImpl<$Res> implements $MovieModelCopyWith<$Res> {
  _$MovieModelCopyWithImpl(this._self, this._then);

  final MovieModel _self;
  final $Res Function(MovieModel) _then;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? msg = freezed,
    Object? movie = freezed,
    Object? episodes = freezed,
  }) {
    return _then(_self.copyWith(
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      msg: freezed == msg
          ? _self.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      movie: freezed == movie
          ? _self.movie
          : movie // ignore: cast_nullable_to_non_nullable
              as MovieDataModel?,
      episodes: freezed == episodes
          ? _self.episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<EpisodeModel>?,
    ));
  }

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MovieDataModelCopyWith<$Res>? get movie {
    if (_self.movie == null) {
      return null;
    }

    return $MovieDataModelCopyWith<$Res>(_self.movie!, (value) {
      return _then(_self.copyWith(movie: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MovieModel].
extension MovieModelPatterns on MovieModel {
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
    TResult Function(_MovieModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieModel() when $default != null:
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
    TResult Function(_MovieModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieModel():
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
    TResult? Function(_MovieModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieModel() when $default != null:
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
            dynamic status,
            @JsonKey(fromJson: _parseStringNullable) String? msg,
            MovieDataModel? movie,
            List<EpisodeModel>? episodes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieModel() when $default != null:
        return $default(_that.status, _that.msg, _that.movie, _that.episodes);
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
            dynamic status,
            @JsonKey(fromJson: _parseStringNullable) String? msg,
            MovieDataModel? movie,
            List<EpisodeModel>? episodes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieModel():
        return $default(_that.status, _that.msg, _that.movie, _that.episodes);
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
            dynamic status,
            @JsonKey(fromJson: _parseStringNullable) String? msg,
            MovieDataModel? movie,
            List<EpisodeModel>? episodes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieModel() when $default != null:
        return $default(_that.status, _that.msg, _that.movie, _that.episodes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MovieModel extends MovieModel {
  const _MovieModel(
      {this.status,
      @JsonKey(fromJson: _parseStringNullable) this.msg,
      this.movie,
      final List<EpisodeModel>? episodes})
      : _episodes = episodes,
        super._();
  factory _MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  @override
  final dynamic status;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? msg;
  @override
  final MovieDataModel? movie;
  final List<EpisodeModel>? _episodes;
  @override
  List<EpisodeModel>? get episodes {
    final value = _episodes;
    if (value == null) return null;
    if (_episodes is EqualUnmodifiableListView) return _episodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MovieModelCopyWith<_MovieModel> get copyWith =>
      __$MovieModelCopyWithImpl<_MovieModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MovieModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MovieModel &&
            const DeepCollectionEquality().equals(other.status, status) &&
            (identical(other.msg, msg) || other.msg == msg) &&
            (identical(other.movie, movie) || other.movie == movie) &&
            const DeepCollectionEquality().equals(other._episodes, _episodes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(status),
      msg,
      movie,
      const DeepCollectionEquality().hash(_episodes));

  @override
  String toString() {
    return 'MovieModel(status: $status, msg: $msg, movie: $movie, episodes: $episodes)';
  }
}

/// @nodoc
abstract mixin class _$MovieModelCopyWith<$Res>
    implements $MovieModelCopyWith<$Res> {
  factory _$MovieModelCopyWith(
          _MovieModel value, $Res Function(_MovieModel) _then) =
      __$MovieModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {dynamic status,
      @JsonKey(fromJson: _parseStringNullable) String? msg,
      MovieDataModel? movie,
      List<EpisodeModel>? episodes});

  @override
  $MovieDataModelCopyWith<$Res>? get movie;
}

/// @nodoc
class __$MovieModelCopyWithImpl<$Res> implements _$MovieModelCopyWith<$Res> {
  __$MovieModelCopyWithImpl(this._self, this._then);

  final _MovieModel _self;
  final $Res Function(_MovieModel) _then;

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = freezed,
    Object? msg = freezed,
    Object? movie = freezed,
    Object? episodes = freezed,
  }) {
    return _then(_MovieModel(
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      msg: freezed == msg
          ? _self.msg
          : msg // ignore: cast_nullable_to_non_nullable
              as String?,
      movie: freezed == movie
          ? _self.movie
          : movie // ignore: cast_nullable_to_non_nullable
              as MovieDataModel?,
      episodes: freezed == episodes
          ? _self._episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<EpisodeModel>?,
    ));
  }

  /// Create a copy of MovieModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MovieDataModelCopyWith<$Res>? get movie {
    if (_self.movie == null) {
      return null;
    }

    return $MovieDataModelCopyWith<$Res>(_self.movie!, (value) {
      return _then(_self.copyWith(movie: value));
    });
  }
}

/// @nodoc
mixin _$MovieDataModel {
  @JsonKey(name: '_id', fromJson: _parseStringNullable)
  String? get id;
  @JsonKey(fromJson: _parseStringNullable)
  String? get name;
  @JsonKey(fromJson: _parseStringNullable)
  String? get slug;
  @JsonKey(name: 'origin_name', fromJson: _parseStringNullable)
  String? get originName;
  @JsonKey(fromJson: _parseStringNullable)
  String? get content;
  @JsonKey(fromJson: _parseStringNullable)
  String? get type;
  dynamic get status;
  @JsonKey(name: 'poster_url', fromJson: _parseStringNullable)
  String? get posterUrl;
  @JsonKey(name: 'thumb_url', fromJson: _parseStringNullable)
  String? get thumbUrl;
  @JsonKey(name: 'trailer_url', fromJson: _parseStringNullable)
  String? get trailerUrl;
  @JsonKey(fromJson: _parseStringNullable)
  String? get time;
  @JsonKey(name: 'episode_current', fromJson: _parseStringNullable)
  String? get episodeCurrent;
  @JsonKey(name: 'episode_total', fromJson: _parseStringNullable)
  String? get episodeTotal;
  @JsonKey(fromJson: _parseStringNullable)
  String? get quality;
  @JsonKey(fromJson: _parseStringNullable)
  String? get lang;
  @JsonKey(fromJson: _parseIntNullable)
  int? get year;
  @JsonKey(fromJson: _parseIntNullable)
  int? get view;
  @JsonKey(fromJson: _parseStringListNullable)
  List<String>? get actor;
  @JsonKey(fromJson: _parseStringListNullable)
  List<String>? get director;
  List<CategoryModel>? get category;
  List<CountryModel>? get country;

  /// Create a copy of MovieDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MovieDataModelCopyWith<MovieDataModel> get copyWith =>
      _$MovieDataModelCopyWithImpl<MovieDataModel>(
          this as MovieDataModel, _$identity);

  /// Serializes this MovieDataModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MovieDataModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.originName, originName) ||
                other.originName == originName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            (identical(other.posterUrl, posterUrl) ||
                other.posterUrl == posterUrl) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            (identical(other.trailerUrl, trailerUrl) ||
                other.trailerUrl == trailerUrl) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.episodeCurrent, episodeCurrent) ||
                other.episodeCurrent == episodeCurrent) &&
            (identical(other.episodeTotal, episodeTotal) ||
                other.episodeTotal == episodeTotal) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.view, view) || other.view == view) &&
            const DeepCollectionEquality().equals(other.actor, actor) &&
            const DeepCollectionEquality().equals(other.director, director) &&
            const DeepCollectionEquality().equals(other.category, category) &&
            const DeepCollectionEquality().equals(other.country, country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        slug,
        originName,
        content,
        type,
        const DeepCollectionEquality().hash(status),
        posterUrl,
        thumbUrl,
        trailerUrl,
        time,
        episodeCurrent,
        episodeTotal,
        quality,
        lang,
        year,
        view,
        const DeepCollectionEquality().hash(actor),
        const DeepCollectionEquality().hash(director),
        const DeepCollectionEquality().hash(category),
        const DeepCollectionEquality().hash(country)
      ]);

  @override
  String toString() {
    return 'MovieDataModel(id: $id, name: $name, slug: $slug, originName: $originName, content: $content, type: $type, status: $status, posterUrl: $posterUrl, thumbUrl: $thumbUrl, trailerUrl: $trailerUrl, time: $time, episodeCurrent: $episodeCurrent, episodeTotal: $episodeTotal, quality: $quality, lang: $lang, year: $year, view: $view, actor: $actor, director: $director, category: $category, country: $country)';
  }
}

/// @nodoc
abstract mixin class $MovieDataModelCopyWith<$Res> {
  factory $MovieDataModelCopyWith(
          MovieDataModel value, $Res Function(MovieDataModel) _then) =
      _$MovieDataModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: '_id', fromJson: _parseStringNullable) String? id,
      @JsonKey(fromJson: _parseStringNullable) String? name,
      @JsonKey(fromJson: _parseStringNullable) String? slug,
      @JsonKey(name: 'origin_name', fromJson: _parseStringNullable)
      String? originName,
      @JsonKey(fromJson: _parseStringNullable) String? content,
      @JsonKey(fromJson: _parseStringNullable) String? type,
      dynamic status,
      @JsonKey(name: 'poster_url', fromJson: _parseStringNullable)
      String? posterUrl,
      @JsonKey(name: 'thumb_url', fromJson: _parseStringNullable)
      String? thumbUrl,
      @JsonKey(name: 'trailer_url', fromJson: _parseStringNullable)
      String? trailerUrl,
      @JsonKey(fromJson: _parseStringNullable) String? time,
      @JsonKey(name: 'episode_current', fromJson: _parseStringNullable)
      String? episodeCurrent,
      @JsonKey(name: 'episode_total', fromJson: _parseStringNullable)
      String? episodeTotal,
      @JsonKey(fromJson: _parseStringNullable) String? quality,
      @JsonKey(fromJson: _parseStringNullable) String? lang,
      @JsonKey(fromJson: _parseIntNullable) int? year,
      @JsonKey(fromJson: _parseIntNullable) int? view,
      @JsonKey(fromJson: _parseStringListNullable) List<String>? actor,
      @JsonKey(fromJson: _parseStringListNullable) List<String>? director,
      List<CategoryModel>? category,
      List<CountryModel>? country});
}

/// @nodoc
class _$MovieDataModelCopyWithImpl<$Res>
    implements $MovieDataModelCopyWith<$Res> {
  _$MovieDataModelCopyWithImpl(this._self, this._then);

  final MovieDataModel _self;
  final $Res Function(MovieDataModel) _then;

  /// Create a copy of MovieDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? originName = freezed,
    Object? content = freezed,
    Object? type = freezed,
    Object? status = freezed,
    Object? posterUrl = freezed,
    Object? thumbUrl = freezed,
    Object? trailerUrl = freezed,
    Object? time = freezed,
    Object? episodeCurrent = freezed,
    Object? episodeTotal = freezed,
    Object? quality = freezed,
    Object? lang = freezed,
    Object? year = freezed,
    Object? view = freezed,
    Object? actor = freezed,
    Object? director = freezed,
    Object? category = freezed,
    Object? country = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      originName: freezed == originName
          ? _self.originName
          : originName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      posterUrl: freezed == posterUrl
          ? _self.posterUrl
          : posterUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbUrl: freezed == thumbUrl
          ? _self.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      trailerUrl: freezed == trailerUrl
          ? _self.trailerUrl
          : trailerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeCurrent: freezed == episodeCurrent
          ? _self.episodeCurrent
          : episodeCurrent // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeTotal: freezed == episodeTotal
          ? _self.episodeTotal
          : episodeTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      quality: freezed == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as String?,
      lang: freezed == lang
          ? _self.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      view: freezed == view
          ? _self.view
          : view // ignore: cast_nullable_to_non_nullable
              as int?,
      actor: freezed == actor
          ? _self.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      director: freezed == director
          ? _self.director
          : director // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>?,
      country: freezed == country
          ? _self.country
          : country // ignore: cast_nullable_to_non_nullable
              as List<CountryModel>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MovieDataModel].
extension MovieDataModelPatterns on MovieDataModel {
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
    TResult Function(_MovieDataModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieDataModel() when $default != null:
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
    TResult Function(_MovieDataModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieDataModel():
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
    TResult? Function(_MovieDataModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieDataModel() when $default != null:
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
            @JsonKey(name: '_id', fromJson: _parseStringNullable) String? id,
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug,
            @JsonKey(name: 'origin_name', fromJson: _parseStringNullable)
            String? originName,
            @JsonKey(fromJson: _parseStringNullable) String? content,
            @JsonKey(fromJson: _parseStringNullable) String? type,
            dynamic status,
            @JsonKey(name: 'poster_url', fromJson: _parseStringNullable)
            String? posterUrl,
            @JsonKey(name: 'thumb_url', fromJson: _parseStringNullable)
            String? thumbUrl,
            @JsonKey(name: 'trailer_url', fromJson: _parseStringNullable)
            String? trailerUrl,
            @JsonKey(fromJson: _parseStringNullable) String? time,
            @JsonKey(name: 'episode_current', fromJson: _parseStringNullable)
            String? episodeCurrent,
            @JsonKey(name: 'episode_total', fromJson: _parseStringNullable)
            String? episodeTotal,
            @JsonKey(fromJson: _parseStringNullable) String? quality,
            @JsonKey(fromJson: _parseStringNullable) String? lang,
            @JsonKey(fromJson: _parseIntNullable) int? year,
            @JsonKey(fromJson: _parseIntNullable) int? view,
            @JsonKey(fromJson: _parseStringListNullable) List<String>? actor,
            @JsonKey(fromJson: _parseStringListNullable) List<String>? director,
            List<CategoryModel>? category,
            List<CountryModel>? country)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MovieDataModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.originName,
            _that.content,
            _that.type,
            _that.status,
            _that.posterUrl,
            _that.thumbUrl,
            _that.trailerUrl,
            _that.time,
            _that.episodeCurrent,
            _that.episodeTotal,
            _that.quality,
            _that.lang,
            _that.year,
            _that.view,
            _that.actor,
            _that.director,
            _that.category,
            _that.country);
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
            @JsonKey(name: '_id', fromJson: _parseStringNullable) String? id,
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug,
            @JsonKey(name: 'origin_name', fromJson: _parseStringNullable)
            String? originName,
            @JsonKey(fromJson: _parseStringNullable) String? content,
            @JsonKey(fromJson: _parseStringNullable) String? type,
            dynamic status,
            @JsonKey(name: 'poster_url', fromJson: _parseStringNullable)
            String? posterUrl,
            @JsonKey(name: 'thumb_url', fromJson: _parseStringNullable)
            String? thumbUrl,
            @JsonKey(name: 'trailer_url', fromJson: _parseStringNullable)
            String? trailerUrl,
            @JsonKey(fromJson: _parseStringNullable) String? time,
            @JsonKey(name: 'episode_current', fromJson: _parseStringNullable)
            String? episodeCurrent,
            @JsonKey(name: 'episode_total', fromJson: _parseStringNullable)
            String? episodeTotal,
            @JsonKey(fromJson: _parseStringNullable) String? quality,
            @JsonKey(fromJson: _parseStringNullable) String? lang,
            @JsonKey(fromJson: _parseIntNullable) int? year,
            @JsonKey(fromJson: _parseIntNullable) int? view,
            @JsonKey(fromJson: _parseStringListNullable) List<String>? actor,
            @JsonKey(fromJson: _parseStringListNullable) List<String>? director,
            List<CategoryModel>? category,
            List<CountryModel>? country)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieDataModel():
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.originName,
            _that.content,
            _that.type,
            _that.status,
            _that.posterUrl,
            _that.thumbUrl,
            _that.trailerUrl,
            _that.time,
            _that.episodeCurrent,
            _that.episodeTotal,
            _that.quality,
            _that.lang,
            _that.year,
            _that.view,
            _that.actor,
            _that.director,
            _that.category,
            _that.country);
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
            @JsonKey(name: '_id', fromJson: _parseStringNullable) String? id,
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug,
            @JsonKey(name: 'origin_name', fromJson: _parseStringNullable)
            String? originName,
            @JsonKey(fromJson: _parseStringNullable) String? content,
            @JsonKey(fromJson: _parseStringNullable) String? type,
            dynamic status,
            @JsonKey(name: 'poster_url', fromJson: _parseStringNullable)
            String? posterUrl,
            @JsonKey(name: 'thumb_url', fromJson: _parseStringNullable)
            String? thumbUrl,
            @JsonKey(name: 'trailer_url', fromJson: _parseStringNullable)
            String? trailerUrl,
            @JsonKey(fromJson: _parseStringNullable) String? time,
            @JsonKey(name: 'episode_current', fromJson: _parseStringNullable)
            String? episodeCurrent,
            @JsonKey(name: 'episode_total', fromJson: _parseStringNullable)
            String? episodeTotal,
            @JsonKey(fromJson: _parseStringNullable) String? quality,
            @JsonKey(fromJson: _parseStringNullable) String? lang,
            @JsonKey(fromJson: _parseIntNullable) int? year,
            @JsonKey(fromJson: _parseIntNullable) int? view,
            @JsonKey(fromJson: _parseStringListNullable) List<String>? actor,
            @JsonKey(fromJson: _parseStringListNullable) List<String>? director,
            List<CategoryModel>? category,
            List<CountryModel>? country)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MovieDataModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.originName,
            _that.content,
            _that.type,
            _that.status,
            _that.posterUrl,
            _that.thumbUrl,
            _that.trailerUrl,
            _that.time,
            _that.episodeCurrent,
            _that.episodeTotal,
            _that.quality,
            _that.lang,
            _that.year,
            _that.view,
            _that.actor,
            _that.director,
            _that.category,
            _that.country);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MovieDataModel extends MovieDataModel {
  const _MovieDataModel(
      {@JsonKey(name: '_id', fromJson: _parseStringNullable) this.id,
      @JsonKey(fromJson: _parseStringNullable) this.name,
      @JsonKey(fromJson: _parseStringNullable) this.slug,
      @JsonKey(name: 'origin_name', fromJson: _parseStringNullable)
      this.originName,
      @JsonKey(fromJson: _parseStringNullable) this.content,
      @JsonKey(fromJson: _parseStringNullable) this.type,
      this.status,
      @JsonKey(name: 'poster_url', fromJson: _parseStringNullable)
      this.posterUrl,
      @JsonKey(name: 'thumb_url', fromJson: _parseStringNullable) this.thumbUrl,
      @JsonKey(name: 'trailer_url', fromJson: _parseStringNullable)
      this.trailerUrl,
      @JsonKey(fromJson: _parseStringNullable) this.time,
      @JsonKey(name: 'episode_current', fromJson: _parseStringNullable)
      this.episodeCurrent,
      @JsonKey(name: 'episode_total', fromJson: _parseStringNullable)
      this.episodeTotal,
      @JsonKey(fromJson: _parseStringNullable) this.quality,
      @JsonKey(fromJson: _parseStringNullable) this.lang,
      @JsonKey(fromJson: _parseIntNullable) this.year,
      @JsonKey(fromJson: _parseIntNullable) this.view,
      @JsonKey(fromJson: _parseStringListNullable) final List<String>? actor,
      @JsonKey(fromJson: _parseStringListNullable) final List<String>? director,
      final List<CategoryModel>? category,
      final List<CountryModel>? country})
      : _actor = actor,
        _director = director,
        _category = category,
        _country = country,
        super._();
  factory _MovieDataModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDataModelFromJson(json);

  @override
  @JsonKey(name: '_id', fromJson: _parseStringNullable)
  final String? id;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? name;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? slug;
  @override
  @JsonKey(name: 'origin_name', fromJson: _parseStringNullable)
  final String? originName;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? content;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? type;
  @override
  final dynamic status;
  @override
  @JsonKey(name: 'poster_url', fromJson: _parseStringNullable)
  final String? posterUrl;
  @override
  @JsonKey(name: 'thumb_url', fromJson: _parseStringNullable)
  final String? thumbUrl;
  @override
  @JsonKey(name: 'trailer_url', fromJson: _parseStringNullable)
  final String? trailerUrl;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? time;
  @override
  @JsonKey(name: 'episode_current', fromJson: _parseStringNullable)
  final String? episodeCurrent;
  @override
  @JsonKey(name: 'episode_total', fromJson: _parseStringNullable)
  final String? episodeTotal;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? quality;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? lang;
  @override
  @JsonKey(fromJson: _parseIntNullable)
  final int? year;
  @override
  @JsonKey(fromJson: _parseIntNullable)
  final int? view;
  final List<String>? _actor;
  @override
  @JsonKey(fromJson: _parseStringListNullable)
  List<String>? get actor {
    final value = _actor;
    if (value == null) return null;
    if (_actor is EqualUnmodifiableListView) return _actor;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _director;
  @override
  @JsonKey(fromJson: _parseStringListNullable)
  List<String>? get director {
    final value = _director;
    if (value == null) return null;
    if (_director is EqualUnmodifiableListView) return _director;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<CategoryModel>? _category;
  @override
  List<CategoryModel>? get category {
    final value = _category;
    if (value == null) return null;
    if (_category is EqualUnmodifiableListView) return _category;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<CountryModel>? _country;
  @override
  List<CountryModel>? get country {
    final value = _country;
    if (value == null) return null;
    if (_country is EqualUnmodifiableListView) return _country;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of MovieDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MovieDataModelCopyWith<_MovieDataModel> get copyWith =>
      __$MovieDataModelCopyWithImpl<_MovieDataModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MovieDataModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MovieDataModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.originName, originName) ||
                other.originName == originName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.status, status) &&
            (identical(other.posterUrl, posterUrl) ||
                other.posterUrl == posterUrl) &&
            (identical(other.thumbUrl, thumbUrl) ||
                other.thumbUrl == thumbUrl) &&
            (identical(other.trailerUrl, trailerUrl) ||
                other.trailerUrl == trailerUrl) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.episodeCurrent, episodeCurrent) ||
                other.episodeCurrent == episodeCurrent) &&
            (identical(other.episodeTotal, episodeTotal) ||
                other.episodeTotal == episodeTotal) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.view, view) || other.view == view) &&
            const DeepCollectionEquality().equals(other._actor, _actor) &&
            const DeepCollectionEquality().equals(other._director, _director) &&
            const DeepCollectionEquality().equals(other._category, _category) &&
            const DeepCollectionEquality().equals(other._country, _country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        slug,
        originName,
        content,
        type,
        const DeepCollectionEquality().hash(status),
        posterUrl,
        thumbUrl,
        trailerUrl,
        time,
        episodeCurrent,
        episodeTotal,
        quality,
        lang,
        year,
        view,
        const DeepCollectionEquality().hash(_actor),
        const DeepCollectionEquality().hash(_director),
        const DeepCollectionEquality().hash(_category),
        const DeepCollectionEquality().hash(_country)
      ]);

  @override
  String toString() {
    return 'MovieDataModel(id: $id, name: $name, slug: $slug, originName: $originName, content: $content, type: $type, status: $status, posterUrl: $posterUrl, thumbUrl: $thumbUrl, trailerUrl: $trailerUrl, time: $time, episodeCurrent: $episodeCurrent, episodeTotal: $episodeTotal, quality: $quality, lang: $lang, year: $year, view: $view, actor: $actor, director: $director, category: $category, country: $country)';
  }
}

/// @nodoc
abstract mixin class _$MovieDataModelCopyWith<$Res>
    implements $MovieDataModelCopyWith<$Res> {
  factory _$MovieDataModelCopyWith(
          _MovieDataModel value, $Res Function(_MovieDataModel) _then) =
      __$MovieDataModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id', fromJson: _parseStringNullable) String? id,
      @JsonKey(fromJson: _parseStringNullable) String? name,
      @JsonKey(fromJson: _parseStringNullable) String? slug,
      @JsonKey(name: 'origin_name', fromJson: _parseStringNullable)
      String? originName,
      @JsonKey(fromJson: _parseStringNullable) String? content,
      @JsonKey(fromJson: _parseStringNullable) String? type,
      dynamic status,
      @JsonKey(name: 'poster_url', fromJson: _parseStringNullable)
      String? posterUrl,
      @JsonKey(name: 'thumb_url', fromJson: _parseStringNullable)
      String? thumbUrl,
      @JsonKey(name: 'trailer_url', fromJson: _parseStringNullable)
      String? trailerUrl,
      @JsonKey(fromJson: _parseStringNullable) String? time,
      @JsonKey(name: 'episode_current', fromJson: _parseStringNullable)
      String? episodeCurrent,
      @JsonKey(name: 'episode_total', fromJson: _parseStringNullable)
      String? episodeTotal,
      @JsonKey(fromJson: _parseStringNullable) String? quality,
      @JsonKey(fromJson: _parseStringNullable) String? lang,
      @JsonKey(fromJson: _parseIntNullable) int? year,
      @JsonKey(fromJson: _parseIntNullable) int? view,
      @JsonKey(fromJson: _parseStringListNullable) List<String>? actor,
      @JsonKey(fromJson: _parseStringListNullable) List<String>? director,
      List<CategoryModel>? category,
      List<CountryModel>? country});
}

/// @nodoc
class __$MovieDataModelCopyWithImpl<$Res>
    implements _$MovieDataModelCopyWith<$Res> {
  __$MovieDataModelCopyWithImpl(this._self, this._then);

  final _MovieDataModel _self;
  final $Res Function(_MovieDataModel) _then;

  /// Create a copy of MovieDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
    Object? originName = freezed,
    Object? content = freezed,
    Object? type = freezed,
    Object? status = freezed,
    Object? posterUrl = freezed,
    Object? thumbUrl = freezed,
    Object? trailerUrl = freezed,
    Object? time = freezed,
    Object? episodeCurrent = freezed,
    Object? episodeTotal = freezed,
    Object? quality = freezed,
    Object? lang = freezed,
    Object? year = freezed,
    Object? view = freezed,
    Object? actor = freezed,
    Object? director = freezed,
    Object? category = freezed,
    Object? country = freezed,
  }) {
    return _then(_MovieDataModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      originName: freezed == originName
          ? _self.originName
          : originName // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as dynamic,
      posterUrl: freezed == posterUrl
          ? _self.posterUrl
          : posterUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbUrl: freezed == thumbUrl
          ? _self.thumbUrl
          : thumbUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      trailerUrl: freezed == trailerUrl
          ? _self.trailerUrl
          : trailerUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _self.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeCurrent: freezed == episodeCurrent
          ? _self.episodeCurrent
          : episodeCurrent // ignore: cast_nullable_to_non_nullable
              as String?,
      episodeTotal: freezed == episodeTotal
          ? _self.episodeTotal
          : episodeTotal // ignore: cast_nullable_to_non_nullable
              as String?,
      quality: freezed == quality
          ? _self.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as String?,
      lang: freezed == lang
          ? _self.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
      year: freezed == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      view: freezed == view
          ? _self.view
          : view // ignore: cast_nullable_to_non_nullable
              as int?,
      actor: freezed == actor
          ? _self._actor
          : actor // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      director: freezed == director
          ? _self._director
          : director // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      category: freezed == category
          ? _self._category
          : category // ignore: cast_nullable_to_non_nullable
              as List<CategoryModel>?,
      country: freezed == country
          ? _self._country
          : country // ignore: cast_nullable_to_non_nullable
              as List<CountryModel>?,
    ));
  }
}

/// @nodoc
mixin _$CategoryModel {
  @JsonKey(fromJson: _parseStringNullable)
  String? get id;
  @JsonKey(fromJson: _parseStringNullable)
  String? get name;
  @JsonKey(fromJson: _parseStringNullable)
  String? get slug;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryModelCopyWith<CategoryModel> get copyWith =>
      _$CategoryModelCopyWithImpl<CategoryModel>(
          this as CategoryModel, _$identity);

  /// Serializes this CategoryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CategoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, slug: $slug)';
  }
}

/// @nodoc
abstract mixin class $CategoryModelCopyWith<$Res> {
  factory $CategoryModelCopyWith(
          CategoryModel value, $Res Function(CategoryModel) _then) =
      _$CategoryModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringNullable) String? id,
      @JsonKey(fromJson: _parseStringNullable) String? name,
      @JsonKey(fromJson: _parseStringNullable) String? slug});
}

/// @nodoc
class _$CategoryModelCopyWithImpl<$Res>
    implements $CategoryModelCopyWith<$Res> {
  _$CategoryModelCopyWithImpl(this._self, this._then);

  final CategoryModel _self;
  final $Res Function(CategoryModel) _then;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CategoryModel].
extension CategoryModelPatterns on CategoryModel {
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
    TResult Function(_CategoryModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryModel() when $default != null:
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
    TResult Function(_CategoryModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryModel():
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
    TResult? Function(_CategoryModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryModel() when $default != null:
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
            @JsonKey(fromJson: _parseStringNullable) String? id,
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CategoryModel() when $default != null:
        return $default(_that.id, _that.name, _that.slug);
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
            @JsonKey(fromJson: _parseStringNullable) String? id,
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryModel():
        return $default(_that.id, _that.name, _that.slug);
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
            @JsonKey(fromJson: _parseStringNullable) String? id,
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CategoryModel() when $default != null:
        return $default(_that.id, _that.name, _that.slug);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CategoryModel implements CategoryModel {
  const _CategoryModel(
      {@JsonKey(fromJson: _parseStringNullable) this.id,
      @JsonKey(fromJson: _parseStringNullable) this.name,
      @JsonKey(fromJson: _parseStringNullable) this.slug});
  factory _CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? id;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? name;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? slug;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryModelCopyWith<_CategoryModel> get copyWith =>
      __$CategoryModelCopyWithImpl<_CategoryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CategoryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, slug: $slug)';
  }
}

/// @nodoc
abstract mixin class _$CategoryModelCopyWith<$Res>
    implements $CategoryModelCopyWith<$Res> {
  factory _$CategoryModelCopyWith(
          _CategoryModel value, $Res Function(_CategoryModel) _then) =
      __$CategoryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringNullable) String? id,
      @JsonKey(fromJson: _parseStringNullable) String? name,
      @JsonKey(fromJson: _parseStringNullable) String? slug});
}

/// @nodoc
class __$CategoryModelCopyWithImpl<$Res>
    implements _$CategoryModelCopyWith<$Res> {
  __$CategoryModelCopyWithImpl(this._self, this._then);

  final _CategoryModel _self;
  final $Res Function(_CategoryModel) _then;

  /// Create a copy of CategoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
  }) {
    return _then(_CategoryModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CountryModel {
  @JsonKey(fromJson: _parseStringNullable)
  String? get id;
  @JsonKey(fromJson: _parseStringNullable)
  String? get name;
  @JsonKey(fromJson: _parseStringNullable)
  String? get slug;

  /// Create a copy of CountryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CountryModelCopyWith<CountryModel> get copyWith =>
      _$CountryModelCopyWithImpl<CountryModel>(
          this as CountryModel, _$identity);

  /// Serializes this CountryModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CountryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  @override
  String toString() {
    return 'CountryModel(id: $id, name: $name, slug: $slug)';
  }
}

/// @nodoc
abstract mixin class $CountryModelCopyWith<$Res> {
  factory $CountryModelCopyWith(
          CountryModel value, $Res Function(CountryModel) _then) =
      _$CountryModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringNullable) String? id,
      @JsonKey(fromJson: _parseStringNullable) String? name,
      @JsonKey(fromJson: _parseStringNullable) String? slug});
}

/// @nodoc
class _$CountryModelCopyWithImpl<$Res> implements $CountryModelCopyWith<$Res> {
  _$CountryModelCopyWithImpl(this._self, this._then);

  final CountryModel _self;
  final $Res Function(CountryModel) _then;

  /// Create a copy of CountryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CountryModel].
extension CountryModelPatterns on CountryModel {
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
    TResult Function(_CountryModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CountryModel() when $default != null:
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
    TResult Function(_CountryModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CountryModel():
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
    TResult? Function(_CountryModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CountryModel() when $default != null:
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
            @JsonKey(fromJson: _parseStringNullable) String? id,
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CountryModel() when $default != null:
        return $default(_that.id, _that.name, _that.slug);
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
            @JsonKey(fromJson: _parseStringNullable) String? id,
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CountryModel():
        return $default(_that.id, _that.name, _that.slug);
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
            @JsonKey(fromJson: _parseStringNullable) String? id,
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CountryModel() when $default != null:
        return $default(_that.id, _that.name, _that.slug);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CountryModel implements CountryModel {
  const _CountryModel(
      {@JsonKey(fromJson: _parseStringNullable) this.id,
      @JsonKey(fromJson: _parseStringNullable) this.name,
      @JsonKey(fromJson: _parseStringNullable) this.slug});
  factory _CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? id;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? name;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? slug;

  /// Create a copy of CountryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CountryModelCopyWith<_CountryModel> get copyWith =>
      __$CountryModelCopyWithImpl<_CountryModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CountryModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CountryModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  @override
  String toString() {
    return 'CountryModel(id: $id, name: $name, slug: $slug)';
  }
}

/// @nodoc
abstract mixin class _$CountryModelCopyWith<$Res>
    implements $CountryModelCopyWith<$Res> {
  factory _$CountryModelCopyWith(
          _CountryModel value, $Res Function(_CountryModel) _then) =
      __$CountryModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringNullable) String? id,
      @JsonKey(fromJson: _parseStringNullable) String? name,
      @JsonKey(fromJson: _parseStringNullable) String? slug});
}

/// @nodoc
class __$CountryModelCopyWithImpl<$Res>
    implements _$CountryModelCopyWith<$Res> {
  __$CountryModelCopyWithImpl(this._self, this._then);

  final _CountryModel _self;
  final $Res Function(_CountryModel) _then;

  /// Create a copy of CountryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? slug = freezed,
  }) {
    return _then(_CountryModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$EpisodeModel {
  @JsonKey(name: 'server_name', fromJson: _parseStringNullable)
  String? get serverName;
  @JsonKey(name: 'server_data')
  List<ServerDataModel>? get serverData;

  /// Create a copy of EpisodeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EpisodeModelCopyWith<EpisodeModel> get copyWith =>
      _$EpisodeModelCopyWithImpl<EpisodeModel>(
          this as EpisodeModel, _$identity);

  /// Serializes this EpisodeModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EpisodeModel &&
            (identical(other.serverName, serverName) ||
                other.serverName == serverName) &&
            const DeepCollectionEquality()
                .equals(other.serverData, serverData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, serverName, const DeepCollectionEquality().hash(serverData));

  @override
  String toString() {
    return 'EpisodeModel(serverName: $serverName, serverData: $serverData)';
  }
}

/// @nodoc
abstract mixin class $EpisodeModelCopyWith<$Res> {
  factory $EpisodeModelCopyWith(
          EpisodeModel value, $Res Function(EpisodeModel) _then) =
      _$EpisodeModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'server_name', fromJson: _parseStringNullable)
      String? serverName,
      @JsonKey(name: 'server_data') List<ServerDataModel>? serverData});
}

/// @nodoc
class _$EpisodeModelCopyWithImpl<$Res> implements $EpisodeModelCopyWith<$Res> {
  _$EpisodeModelCopyWithImpl(this._self, this._then);

  final EpisodeModel _self;
  final $Res Function(EpisodeModel) _then;

  /// Create a copy of EpisodeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serverName = freezed,
    Object? serverData = freezed,
  }) {
    return _then(_self.copyWith(
      serverName: freezed == serverName
          ? _self.serverName
          : serverName // ignore: cast_nullable_to_non_nullable
              as String?,
      serverData: freezed == serverData
          ? _self.serverData
          : serverData // ignore: cast_nullable_to_non_nullable
              as List<ServerDataModel>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [EpisodeModel].
extension EpisodeModelPatterns on EpisodeModel {
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
    TResult Function(_EpisodeModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EpisodeModel() when $default != null:
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
    TResult Function(_EpisodeModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EpisodeModel():
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
    TResult? Function(_EpisodeModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EpisodeModel() when $default != null:
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
            @JsonKey(name: 'server_name', fromJson: _parseStringNullable)
            String? serverName,
            @JsonKey(name: 'server_data') List<ServerDataModel>? serverData)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EpisodeModel() when $default != null:
        return $default(_that.serverName, _that.serverData);
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
            @JsonKey(name: 'server_name', fromJson: _parseStringNullable)
            String? serverName,
            @JsonKey(name: 'server_data') List<ServerDataModel>? serverData)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EpisodeModel():
        return $default(_that.serverName, _that.serverData);
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
            @JsonKey(name: 'server_name', fromJson: _parseStringNullable)
            String? serverName,
            @JsonKey(name: 'server_data') List<ServerDataModel>? serverData)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EpisodeModel() when $default != null:
        return $default(_that.serverName, _that.serverData);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _EpisodeModel extends EpisodeModel {
  const _EpisodeModel(
      {@JsonKey(name: 'server_name', fromJson: _parseStringNullable)
      this.serverName,
      @JsonKey(name: 'server_data') final List<ServerDataModel>? serverData})
      : _serverData = serverData,
        super._();
  factory _EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);

  @override
  @JsonKey(name: 'server_name', fromJson: _parseStringNullable)
  final String? serverName;
  final List<ServerDataModel>? _serverData;
  @override
  @JsonKey(name: 'server_data')
  List<ServerDataModel>? get serverData {
    final value = _serverData;
    if (value == null) return null;
    if (_serverData is EqualUnmodifiableListView) return _serverData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of EpisodeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EpisodeModelCopyWith<_EpisodeModel> get copyWith =>
      __$EpisodeModelCopyWithImpl<_EpisodeModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EpisodeModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EpisodeModel &&
            (identical(other.serverName, serverName) ||
                other.serverName == serverName) &&
            const DeepCollectionEquality()
                .equals(other._serverData, _serverData));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, serverName,
      const DeepCollectionEquality().hash(_serverData));

  @override
  String toString() {
    return 'EpisodeModel(serverName: $serverName, serverData: $serverData)';
  }
}

/// @nodoc
abstract mixin class _$EpisodeModelCopyWith<$Res>
    implements $EpisodeModelCopyWith<$Res> {
  factory _$EpisodeModelCopyWith(
          _EpisodeModel value, $Res Function(_EpisodeModel) _then) =
      __$EpisodeModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'server_name', fromJson: _parseStringNullable)
      String? serverName,
      @JsonKey(name: 'server_data') List<ServerDataModel>? serverData});
}

/// @nodoc
class __$EpisodeModelCopyWithImpl<$Res>
    implements _$EpisodeModelCopyWith<$Res> {
  __$EpisodeModelCopyWithImpl(this._self, this._then);

  final _EpisodeModel _self;
  final $Res Function(_EpisodeModel) _then;

  /// Create a copy of EpisodeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? serverName = freezed,
    Object? serverData = freezed,
  }) {
    return _then(_EpisodeModel(
      serverName: freezed == serverName
          ? _self.serverName
          : serverName // ignore: cast_nullable_to_non_nullable
              as String?,
      serverData: freezed == serverData
          ? _self._serverData
          : serverData // ignore: cast_nullable_to_non_nullable
              as List<ServerDataModel>?,
    ));
  }
}

/// @nodoc
mixin _$ServerDataModel {
  @JsonKey(fromJson: _parseStringNullable)
  String? get name;
  @JsonKey(fromJson: _parseStringNullable)
  String? get slug;
  @JsonKey(fromJson: _parseStringNullable)
  String? get filename;
  @JsonKey(name: 'link_embed', fromJson: _parseStringNullable)
  String? get linkEmbed;
  @JsonKey(name: 'link_m3u8', fromJson: _parseStringNullable)
  String? get linkM3u8;

  /// Create a copy of ServerDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ServerDataModelCopyWith<ServerDataModel> get copyWith =>
      _$ServerDataModelCopyWithImpl<ServerDataModel>(
          this as ServerDataModel, _$identity);

  /// Serializes this ServerDataModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ServerDataModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.linkEmbed, linkEmbed) ||
                other.linkEmbed == linkEmbed) &&
            (identical(other.linkM3u8, linkM3u8) ||
                other.linkM3u8 == linkM3u8));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, slug, filename, linkEmbed, linkM3u8);

  @override
  String toString() {
    return 'ServerDataModel(name: $name, slug: $slug, filename: $filename, linkEmbed: $linkEmbed, linkM3u8: $linkM3u8)';
  }
}

/// @nodoc
abstract mixin class $ServerDataModelCopyWith<$Res> {
  factory $ServerDataModelCopyWith(
          ServerDataModel value, $Res Function(ServerDataModel) _then) =
      _$ServerDataModelCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringNullable) String? name,
      @JsonKey(fromJson: _parseStringNullable) String? slug,
      @JsonKey(fromJson: _parseStringNullable) String? filename,
      @JsonKey(name: 'link_embed', fromJson: _parseStringNullable)
      String? linkEmbed,
      @JsonKey(name: 'link_m3u8', fromJson: _parseStringNullable)
      String? linkM3u8});
}

/// @nodoc
class _$ServerDataModelCopyWithImpl<$Res>
    implements $ServerDataModelCopyWith<$Res> {
  _$ServerDataModelCopyWithImpl(this._self, this._then);

  final ServerDataModel _self;
  final $Res Function(ServerDataModel) _then;

  /// Create a copy of ServerDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? slug = freezed,
    Object? filename = freezed,
    Object? linkEmbed = freezed,
    Object? linkM3u8 = freezed,
  }) {
    return _then(_self.copyWith(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      filename: freezed == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String?,
      linkEmbed: freezed == linkEmbed
          ? _self.linkEmbed
          : linkEmbed // ignore: cast_nullable_to_non_nullable
              as String?,
      linkM3u8: freezed == linkM3u8
          ? _self.linkM3u8
          : linkM3u8 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ServerDataModel].
extension ServerDataModelPatterns on ServerDataModel {
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
    TResult Function(_ServerDataModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ServerDataModel() when $default != null:
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
    TResult Function(_ServerDataModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ServerDataModel():
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
    TResult? Function(_ServerDataModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ServerDataModel() when $default != null:
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
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug,
            @JsonKey(fromJson: _parseStringNullable) String? filename,
            @JsonKey(name: 'link_embed', fromJson: _parseStringNullable)
            String? linkEmbed,
            @JsonKey(name: 'link_m3u8', fromJson: _parseStringNullable)
            String? linkM3u8)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ServerDataModel() when $default != null:
        return $default(_that.name, _that.slug, _that.filename, _that.linkEmbed,
            _that.linkM3u8);
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
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug,
            @JsonKey(fromJson: _parseStringNullable) String? filename,
            @JsonKey(name: 'link_embed', fromJson: _parseStringNullable)
            String? linkEmbed,
            @JsonKey(name: 'link_m3u8', fromJson: _parseStringNullable)
            String? linkM3u8)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ServerDataModel():
        return $default(_that.name, _that.slug, _that.filename, _that.linkEmbed,
            _that.linkM3u8);
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
            @JsonKey(fromJson: _parseStringNullable) String? name,
            @JsonKey(fromJson: _parseStringNullable) String? slug,
            @JsonKey(fromJson: _parseStringNullable) String? filename,
            @JsonKey(name: 'link_embed', fromJson: _parseStringNullable)
            String? linkEmbed,
            @JsonKey(name: 'link_m3u8', fromJson: _parseStringNullable)
            String? linkM3u8)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ServerDataModel() when $default != null:
        return $default(_that.name, _that.slug, _that.filename, _that.linkEmbed,
            _that.linkM3u8);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ServerDataModel extends ServerDataModel {
  const _ServerDataModel(
      {@JsonKey(fromJson: _parseStringNullable) this.name,
      @JsonKey(fromJson: _parseStringNullable) this.slug,
      @JsonKey(fromJson: _parseStringNullable) this.filename,
      @JsonKey(name: 'link_embed', fromJson: _parseStringNullable)
      this.linkEmbed,
      @JsonKey(name: 'link_m3u8', fromJson: _parseStringNullable)
      this.linkM3u8})
      : super._();
  factory _ServerDataModel.fromJson(Map<String, dynamic> json) =>
      _$ServerDataModelFromJson(json);

  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? name;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? slug;
  @override
  @JsonKey(fromJson: _parseStringNullable)
  final String? filename;
  @override
  @JsonKey(name: 'link_embed', fromJson: _parseStringNullable)
  final String? linkEmbed;
  @override
  @JsonKey(name: 'link_m3u8', fromJson: _parseStringNullable)
  final String? linkM3u8;

  /// Create a copy of ServerDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ServerDataModelCopyWith<_ServerDataModel> get copyWith =>
      __$ServerDataModelCopyWithImpl<_ServerDataModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ServerDataModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ServerDataModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.filename, filename) ||
                other.filename == filename) &&
            (identical(other.linkEmbed, linkEmbed) ||
                other.linkEmbed == linkEmbed) &&
            (identical(other.linkM3u8, linkM3u8) ||
                other.linkM3u8 == linkM3u8));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, slug, filename, linkEmbed, linkM3u8);

  @override
  String toString() {
    return 'ServerDataModel(name: $name, slug: $slug, filename: $filename, linkEmbed: $linkEmbed, linkM3u8: $linkM3u8)';
  }
}

/// @nodoc
abstract mixin class _$ServerDataModelCopyWith<$Res>
    implements $ServerDataModelCopyWith<$Res> {
  factory _$ServerDataModelCopyWith(
          _ServerDataModel value, $Res Function(_ServerDataModel) _then) =
      __$ServerDataModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseStringNullable) String? name,
      @JsonKey(fromJson: _parseStringNullable) String? slug,
      @JsonKey(fromJson: _parseStringNullable) String? filename,
      @JsonKey(name: 'link_embed', fromJson: _parseStringNullable)
      String? linkEmbed,
      @JsonKey(name: 'link_m3u8', fromJson: _parseStringNullable)
      String? linkM3u8});
}

/// @nodoc
class __$ServerDataModelCopyWithImpl<$Res>
    implements _$ServerDataModelCopyWith<$Res> {
  __$ServerDataModelCopyWithImpl(this._self, this._then);

  final _ServerDataModel _self;
  final $Res Function(_ServerDataModel) _then;

  /// Create a copy of ServerDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = freezed,
    Object? slug = freezed,
    Object? filename = freezed,
    Object? linkEmbed = freezed,
    Object? linkM3u8 = freezed,
  }) {
    return _then(_ServerDataModel(
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      filename: freezed == filename
          ? _self.filename
          : filename // ignore: cast_nullable_to_non_nullable
              as String?,
      linkEmbed: freezed == linkEmbed
          ? _self.linkEmbed
          : linkEmbed // ignore: cast_nullable_to_non_nullable
              as String?,
      linkM3u8: freezed == linkM3u8
          ? _self.linkM3u8
          : linkM3u8 // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
