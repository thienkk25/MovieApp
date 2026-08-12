// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchHistoryState {
  WatchHistoryStatus get status;
  List<WatchHistoryEntity> get history;
  String? get errorMessage;

  /// Create a copy of WatchHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WatchHistoryStateCopyWith<WatchHistoryState> get copyWith =>
      _$WatchHistoryStateCopyWithImpl<WatchHistoryState>(
          this as WatchHistoryState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WatchHistoryState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other.history, history) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status,
      const DeepCollectionEquality().hash(history), errorMessage);

  @override
  String toString() {
    return 'WatchHistoryState(status: $status, history: $history, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $WatchHistoryStateCopyWith<$Res> {
  factory $WatchHistoryStateCopyWith(
          WatchHistoryState value, $Res Function(WatchHistoryState) _then) =
      _$WatchHistoryStateCopyWithImpl;
  @useResult
  $Res call(
      {WatchHistoryStatus status,
      List<WatchHistoryEntity> history,
      String? errorMessage});
}

/// @nodoc
class _$WatchHistoryStateCopyWithImpl<$Res>
    implements $WatchHistoryStateCopyWith<$Res> {
  _$WatchHistoryStateCopyWithImpl(this._self, this._then);

  final WatchHistoryState _self;
  final $Res Function(WatchHistoryState) _then;

  /// Create a copy of WatchHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? history = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as WatchHistoryStatus,
      history: null == history
          ? _self.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<WatchHistoryEntity>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [WatchHistoryState].
extension WatchHistoryStatePatterns on WatchHistoryState {
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
    TResult Function(_WatchHistoryState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WatchHistoryState() when $default != null:
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
    TResult Function(_WatchHistoryState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WatchHistoryState():
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
    TResult? Function(_WatchHistoryState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WatchHistoryState() when $default != null:
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
    TResult Function(WatchHistoryStatus status,
            List<WatchHistoryEntity> history, String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _WatchHistoryState() when $default != null:
        return $default(_that.status, _that.history, _that.errorMessage);
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
    TResult Function(WatchHistoryStatus status,
            List<WatchHistoryEntity> history, String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WatchHistoryState():
        return $default(_that.status, _that.history, _that.errorMessage);
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
    TResult? Function(WatchHistoryStatus status,
            List<WatchHistoryEntity> history, String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _WatchHistoryState() when $default != null:
        return $default(_that.status, _that.history, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _WatchHistoryState implements WatchHistoryState {
  const _WatchHistoryState(
      {this.status = WatchHistoryStatus.initial,
      final List<WatchHistoryEntity> history = const [],
      this.errorMessage})
      : _history = history;

  @override
  @JsonKey()
  final WatchHistoryStatus status;
  final List<WatchHistoryEntity> _history;
  @override
  @JsonKey()
  List<WatchHistoryEntity> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  final String? errorMessage;

  /// Create a copy of WatchHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$WatchHistoryStateCopyWith<_WatchHistoryState> get copyWith =>
      __$WatchHistoryStateCopyWithImpl<_WatchHistoryState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _WatchHistoryState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._history, _history) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status,
      const DeepCollectionEquality().hash(_history), errorMessage);

  @override
  String toString() {
    return 'WatchHistoryState(status: $status, history: $history, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$WatchHistoryStateCopyWith<$Res>
    implements $WatchHistoryStateCopyWith<$Res> {
  factory _$WatchHistoryStateCopyWith(
          _WatchHistoryState value, $Res Function(_WatchHistoryState) _then) =
      __$WatchHistoryStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {WatchHistoryStatus status,
      List<WatchHistoryEntity> history,
      String? errorMessage});
}

/// @nodoc
class __$WatchHistoryStateCopyWithImpl<$Res>
    implements _$WatchHistoryStateCopyWith<$Res> {
  __$WatchHistoryStateCopyWithImpl(this._self, this._then);

  final _WatchHistoryState _self;
  final $Res Function(_WatchHistoryState) _then;

  /// Create a copy of WatchHistoryState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? history = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_WatchHistoryState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as WatchHistoryStatus,
      history: null == history
          ? _self._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<WatchHistoryEntity>,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
