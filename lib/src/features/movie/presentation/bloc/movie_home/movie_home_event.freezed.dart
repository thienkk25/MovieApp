// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movie_home_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MovieHomeEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MovieHomeEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieHomeEvent()';
  }
}

/// @nodoc
class $MovieHomeEventCopyWith<$Res> {
  $MovieHomeEventCopyWith(MovieHomeEvent _, $Res Function(MovieHomeEvent) __);
}

/// Adds pattern-matching-related methods to [MovieHomeEvent].
extension MovieHomeEventPatterns on MovieHomeEvent {
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
    TResult Function(FetchHomeData value)? fetchHomeData,
    TResult Function(SelectCategory value)? selectCategory,
    TResult Function(LoadMoreNewlyUpdated value)? loadMoreNewlyUpdated,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FetchHomeData() when fetchHomeData != null:
        return fetchHomeData(_that);
      case SelectCategory() when selectCategory != null:
        return selectCategory(_that);
      case LoadMoreNewlyUpdated() when loadMoreNewlyUpdated != null:
        return loadMoreNewlyUpdated(_that);
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
    required TResult Function(FetchHomeData value) fetchHomeData,
    required TResult Function(SelectCategory value) selectCategory,
    required TResult Function(LoadMoreNewlyUpdated value) loadMoreNewlyUpdated,
  }) {
    final _that = this;
    switch (_that) {
      case FetchHomeData():
        return fetchHomeData(_that);
      case SelectCategory():
        return selectCategory(_that);
      case LoadMoreNewlyUpdated():
        return loadMoreNewlyUpdated(_that);
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
    TResult? Function(FetchHomeData value)? fetchHomeData,
    TResult? Function(SelectCategory value)? selectCategory,
    TResult? Function(LoadMoreNewlyUpdated value)? loadMoreNewlyUpdated,
  }) {
    final _that = this;
    switch (_that) {
      case FetchHomeData() when fetchHomeData != null:
        return fetchHomeData(_that);
      case SelectCategory() when selectCategory != null:
        return selectCategory(_that);
      case LoadMoreNewlyUpdated() when loadMoreNewlyUpdated != null:
        return loadMoreNewlyUpdated(_that);
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
    TResult Function()? fetchHomeData,
    TResult Function(String categorySlug)? selectCategory,
    TResult Function()? loadMoreNewlyUpdated,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case FetchHomeData() when fetchHomeData != null:
        return fetchHomeData();
      case SelectCategory() when selectCategory != null:
        return selectCategory(_that.categorySlug);
      case LoadMoreNewlyUpdated() when loadMoreNewlyUpdated != null:
        return loadMoreNewlyUpdated();
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
    required TResult Function() fetchHomeData,
    required TResult Function(String categorySlug) selectCategory,
    required TResult Function() loadMoreNewlyUpdated,
  }) {
    final _that = this;
    switch (_that) {
      case FetchHomeData():
        return fetchHomeData();
      case SelectCategory():
        return selectCategory(_that.categorySlug);
      case LoadMoreNewlyUpdated():
        return loadMoreNewlyUpdated();
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
    TResult? Function()? fetchHomeData,
    TResult? Function(String categorySlug)? selectCategory,
    TResult? Function()? loadMoreNewlyUpdated,
  }) {
    final _that = this;
    switch (_that) {
      case FetchHomeData() when fetchHomeData != null:
        return fetchHomeData();
      case SelectCategory() when selectCategory != null:
        return selectCategory(_that.categorySlug);
      case LoadMoreNewlyUpdated() when loadMoreNewlyUpdated != null:
        return loadMoreNewlyUpdated();
      case _:
        return null;
    }
  }
}

/// @nodoc

class FetchHomeData implements MovieHomeEvent {
  const FetchHomeData();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is FetchHomeData);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieHomeEvent.fetchHomeData()';
  }
}

/// @nodoc

class SelectCategory implements MovieHomeEvent {
  const SelectCategory(this.categorySlug);

  final String categorySlug;

  /// Create a copy of MovieHomeEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SelectCategoryCopyWith<SelectCategory> get copyWith =>
      _$SelectCategoryCopyWithImpl<SelectCategory>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SelectCategory &&
            (identical(other.categorySlug, categorySlug) ||
                other.categorySlug == categorySlug));
  }

  @override
  int get hashCode => Object.hash(runtimeType, categorySlug);

  @override
  String toString() {
    return 'MovieHomeEvent.selectCategory(categorySlug: $categorySlug)';
  }
}

/// @nodoc
abstract mixin class $SelectCategoryCopyWith<$Res>
    implements $MovieHomeEventCopyWith<$Res> {
  factory $SelectCategoryCopyWith(
          SelectCategory value, $Res Function(SelectCategory) _then) =
      _$SelectCategoryCopyWithImpl;
  @useResult
  $Res call({String categorySlug});
}

/// @nodoc
class _$SelectCategoryCopyWithImpl<$Res>
    implements $SelectCategoryCopyWith<$Res> {
  _$SelectCategoryCopyWithImpl(this._self, this._then);

  final SelectCategory _self;
  final $Res Function(SelectCategory) _then;

  /// Create a copy of MovieHomeEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? categorySlug = null,
  }) {
    return _then(SelectCategory(
      null == categorySlug
          ? _self.categorySlug
          : categorySlug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class LoadMoreNewlyUpdated implements MovieHomeEvent {
  const LoadMoreNewlyUpdated();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoadMoreNewlyUpdated);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MovieHomeEvent.loadMoreNewlyUpdated()';
  }
}

// dart format on
