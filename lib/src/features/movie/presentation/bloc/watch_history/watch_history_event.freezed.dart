// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_history_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchHistoryEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WatchHistoryEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WatchHistoryEvent()';
  }
}

/// @nodoc
class $WatchHistoryEventCopyWith<$Res> {
  $WatchHistoryEventCopyWith(
      WatchHistoryEvent _, $Res Function(WatchHistoryEvent) __);
}

/// Adds pattern-matching-related methods to [WatchHistoryEvent].
extension WatchHistoryEventPatterns on WatchHistoryEvent {
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
    TResult Function(LoadWatchHistory value)? loadHistory,
    TResult Function(AddToWatchHistory value)? addToHistory,
    TResult Function(RemoveFromWatchHistory value)? removeFromHistory,
    TResult Function(ClearWatchHistory value)? clearHistory,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoadWatchHistory() when loadHistory != null:
        return loadHistory(_that);
      case AddToWatchHistory() when addToHistory != null:
        return addToHistory(_that);
      case RemoveFromWatchHistory() when removeFromHistory != null:
        return removeFromHistory(_that);
      case ClearWatchHistory() when clearHistory != null:
        return clearHistory(_that);
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
    required TResult Function(LoadWatchHistory value) loadHistory,
    required TResult Function(AddToWatchHistory value) addToHistory,
    required TResult Function(RemoveFromWatchHistory value) removeFromHistory,
    required TResult Function(ClearWatchHistory value) clearHistory,
  }) {
    final _that = this;
    switch (_that) {
      case LoadWatchHistory():
        return loadHistory(_that);
      case AddToWatchHistory():
        return addToHistory(_that);
      case RemoveFromWatchHistory():
        return removeFromHistory(_that);
      case ClearWatchHistory():
        return clearHistory(_that);
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
    TResult? Function(LoadWatchHistory value)? loadHistory,
    TResult? Function(AddToWatchHistory value)? addToHistory,
    TResult? Function(RemoveFromWatchHistory value)? removeFromHistory,
    TResult? Function(ClearWatchHistory value)? clearHistory,
  }) {
    final _that = this;
    switch (_that) {
      case LoadWatchHistory() when loadHistory != null:
        return loadHistory(_that);
      case AddToWatchHistory() when addToHistory != null:
        return addToHistory(_that);
      case RemoveFromWatchHistory() when removeFromHistory != null:
        return removeFromHistory(_that);
      case ClearWatchHistory() when clearHistory != null:
        return clearHistory(_that);
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
    TResult Function()? loadHistory,
    TResult Function(WatchHistoryEntity entry)? addToHistory,
    TResult Function(String slug)? removeFromHistory,
    TResult Function()? clearHistory,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LoadWatchHistory() when loadHistory != null:
        return loadHistory();
      case AddToWatchHistory() when addToHistory != null:
        return addToHistory(_that.entry);
      case RemoveFromWatchHistory() when removeFromHistory != null:
        return removeFromHistory(_that.slug);
      case ClearWatchHistory() when clearHistory != null:
        return clearHistory();
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
    required TResult Function() loadHistory,
    required TResult Function(WatchHistoryEntity entry) addToHistory,
    required TResult Function(String slug) removeFromHistory,
    required TResult Function() clearHistory,
  }) {
    final _that = this;
    switch (_that) {
      case LoadWatchHistory():
        return loadHistory();
      case AddToWatchHistory():
        return addToHistory(_that.entry);
      case RemoveFromWatchHistory():
        return removeFromHistory(_that.slug);
      case ClearWatchHistory():
        return clearHistory();
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
    TResult? Function()? loadHistory,
    TResult? Function(WatchHistoryEntity entry)? addToHistory,
    TResult? Function(String slug)? removeFromHistory,
    TResult? Function()? clearHistory,
  }) {
    final _that = this;
    switch (_that) {
      case LoadWatchHistory() when loadHistory != null:
        return loadHistory();
      case AddToWatchHistory() when addToHistory != null:
        return addToHistory(_that.entry);
      case RemoveFromWatchHistory() when removeFromHistory != null:
        return removeFromHistory(_that.slug);
      case ClearWatchHistory() when clearHistory != null:
        return clearHistory();
      case _:
        return null;
    }
  }
}

/// @nodoc

class LoadWatchHistory implements WatchHistoryEvent {
  const LoadWatchHistory();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LoadWatchHistory);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WatchHistoryEvent.loadHistory()';
  }
}

/// @nodoc

class AddToWatchHistory implements WatchHistoryEvent {
  const AddToWatchHistory(this.entry);

  final WatchHistoryEntity entry;

  /// Create a copy of WatchHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddToWatchHistoryCopyWith<AddToWatchHistory> get copyWith =>
      _$AddToWatchHistoryCopyWithImpl<AddToWatchHistory>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddToWatchHistory &&
            (identical(other.entry, entry) || other.entry == entry));
  }

  @override
  int get hashCode => Object.hash(runtimeType, entry);

  @override
  String toString() {
    return 'WatchHistoryEvent.addToHistory(entry: $entry)';
  }
}

/// @nodoc
abstract mixin class $AddToWatchHistoryCopyWith<$Res>
    implements $WatchHistoryEventCopyWith<$Res> {
  factory $AddToWatchHistoryCopyWith(
          AddToWatchHistory value, $Res Function(AddToWatchHistory) _then) =
      _$AddToWatchHistoryCopyWithImpl;
  @useResult
  $Res call({WatchHistoryEntity entry});
}

/// @nodoc
class _$AddToWatchHistoryCopyWithImpl<$Res>
    implements $AddToWatchHistoryCopyWith<$Res> {
  _$AddToWatchHistoryCopyWithImpl(this._self, this._then);

  final AddToWatchHistory _self;
  final $Res Function(AddToWatchHistory) _then;

  /// Create a copy of WatchHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? entry = null,
  }) {
    return _then(AddToWatchHistory(
      null == entry
          ? _self.entry
          : entry // ignore: cast_nullable_to_non_nullable
              as WatchHistoryEntity,
    ));
  }
}

/// @nodoc

class RemoveFromWatchHistory implements WatchHistoryEvent {
  const RemoveFromWatchHistory(this.slug);

  final String slug;

  /// Create a copy of WatchHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RemoveFromWatchHistoryCopyWith<RemoveFromWatchHistory> get copyWith =>
      _$RemoveFromWatchHistoryCopyWithImpl<RemoveFromWatchHistory>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RemoveFromWatchHistory &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @override
  int get hashCode => Object.hash(runtimeType, slug);

  @override
  String toString() {
    return 'WatchHistoryEvent.removeFromHistory(slug: $slug)';
  }
}

/// @nodoc
abstract mixin class $RemoveFromWatchHistoryCopyWith<$Res>
    implements $WatchHistoryEventCopyWith<$Res> {
  factory $RemoveFromWatchHistoryCopyWith(RemoveFromWatchHistory value,
          $Res Function(RemoveFromWatchHistory) _then) =
      _$RemoveFromWatchHistoryCopyWithImpl;
  @useResult
  $Res call({String slug});
}

/// @nodoc
class _$RemoveFromWatchHistoryCopyWithImpl<$Res>
    implements $RemoveFromWatchHistoryCopyWith<$Res> {
  _$RemoveFromWatchHistoryCopyWithImpl(this._self, this._then);

  final RemoveFromWatchHistory _self;
  final $Res Function(RemoveFromWatchHistory) _then;

  /// Create a copy of WatchHistoryEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? slug = null,
  }) {
    return _then(RemoveFromWatchHistory(
      null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class ClearWatchHistory implements WatchHistoryEvent {
  const ClearWatchHistory();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ClearWatchHistory);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WatchHistoryEvent.clearHistory()';
  }
}

// dart format on
