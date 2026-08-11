// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthEvent {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent()';
  }
}

/// @nodoc
class $AuthEventCopyWith<$Res> {
  $AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}

/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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
    TResult Function(AuthLoginRequested value)? loginRequested,
    TResult Function(AuthRegisterRequested value)? registerRequested,
    TResult Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    TResult Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    TResult Function(AuthFacebookSignInRequested value)?
        facebookSignInRequested,
    TResult Function(AuthLogoutRequested value)? logoutRequested,
    TResult Function(AuthCheckStatus value)? checkAuthStatus,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that);
      case AuthRegisterRequested() when registerRequested != null:
        return registerRequested(_that);
      case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
        return forgotPasswordRequested(_that);
      case AuthGoogleSignInRequested() when googleSignInRequested != null:
        return googleSignInRequested(_that);
      case AuthFacebookSignInRequested() when facebookSignInRequested != null:
        return facebookSignInRequested(_that);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested(_that);
      case AuthCheckStatus() when checkAuthStatus != null:
        return checkAuthStatus(_that);
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
    required TResult Function(AuthLoginRequested value) loginRequested,
    required TResult Function(AuthRegisterRequested value) registerRequested,
    required TResult Function(AuthForgotPasswordRequested value)
        forgotPasswordRequested,
    required TResult Function(AuthGoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(AuthFacebookSignInRequested value)
        facebookSignInRequested,
    required TResult Function(AuthLogoutRequested value) logoutRequested,
    required TResult Function(AuthCheckStatus value) checkAuthStatus,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested():
        return loginRequested(_that);
      case AuthRegisterRequested():
        return registerRequested(_that);
      case AuthForgotPasswordRequested():
        return forgotPasswordRequested(_that);
      case AuthGoogleSignInRequested():
        return googleSignInRequested(_that);
      case AuthFacebookSignInRequested():
        return facebookSignInRequested(_that);
      case AuthLogoutRequested():
        return logoutRequested(_that);
      case AuthCheckStatus():
        return checkAuthStatus(_that);
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
    TResult? Function(AuthLoginRequested value)? loginRequested,
    TResult? Function(AuthRegisterRequested value)? registerRequested,
    TResult? Function(AuthForgotPasswordRequested value)?
        forgotPasswordRequested,
    TResult? Function(AuthGoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(AuthFacebookSignInRequested value)?
        facebookSignInRequested,
    TResult? Function(AuthLogoutRequested value)? logoutRequested,
    TResult? Function(AuthCheckStatus value)? checkAuthStatus,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that);
      case AuthRegisterRequested() when registerRequested != null:
        return registerRequested(_that);
      case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
        return forgotPasswordRequested(_that);
      case AuthGoogleSignInRequested() when googleSignInRequested != null:
        return googleSignInRequested(_that);
      case AuthFacebookSignInRequested() when facebookSignInRequested != null:
        return facebookSignInRequested(_that);
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested(_that);
      case AuthCheckStatus() when checkAuthStatus != null:
        return checkAuthStatus(_that);
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
    TResult Function(String email, String password)? loginRequested,
    TResult Function(String email, String password)? registerRequested,
    TResult Function(String email)? forgotPasswordRequested,
    TResult Function()? googleSignInRequested,
    TResult Function()? facebookSignInRequested,
    TResult Function()? logoutRequested,
    TResult Function()? checkAuthStatus,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that.email, _that.password);
      case AuthRegisterRequested() when registerRequested != null:
        return registerRequested(_that.email, _that.password);
      case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
        return forgotPasswordRequested(_that.email);
      case AuthGoogleSignInRequested() when googleSignInRequested != null:
        return googleSignInRequested();
      case AuthFacebookSignInRequested() when facebookSignInRequested != null:
        return facebookSignInRequested();
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested();
      case AuthCheckStatus() when checkAuthStatus != null:
        return checkAuthStatus();
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
    required TResult Function(String email, String password) loginRequested,
    required TResult Function(String email, String password) registerRequested,
    required TResult Function(String email) forgotPasswordRequested,
    required TResult Function() googleSignInRequested,
    required TResult Function() facebookSignInRequested,
    required TResult Function() logoutRequested,
    required TResult Function() checkAuthStatus,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested():
        return loginRequested(_that.email, _that.password);
      case AuthRegisterRequested():
        return registerRequested(_that.email, _that.password);
      case AuthForgotPasswordRequested():
        return forgotPasswordRequested(_that.email);
      case AuthGoogleSignInRequested():
        return googleSignInRequested();
      case AuthFacebookSignInRequested():
        return facebookSignInRequested();
      case AuthLogoutRequested():
        return logoutRequested();
      case AuthCheckStatus():
        return checkAuthStatus();
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
    TResult? Function(String email, String password)? loginRequested,
    TResult? Function(String email, String password)? registerRequested,
    TResult? Function(String email)? forgotPasswordRequested,
    TResult? Function()? googleSignInRequested,
    TResult? Function()? facebookSignInRequested,
    TResult? Function()? logoutRequested,
    TResult? Function()? checkAuthStatus,
  }) {
    final _that = this;
    switch (_that) {
      case AuthLoginRequested() when loginRequested != null:
        return loginRequested(_that.email, _that.password);
      case AuthRegisterRequested() when registerRequested != null:
        return registerRequested(_that.email, _that.password);
      case AuthForgotPasswordRequested() when forgotPasswordRequested != null:
        return forgotPasswordRequested(_that.email);
      case AuthGoogleSignInRequested() when googleSignInRequested != null:
        return googleSignInRequested();
      case AuthFacebookSignInRequested() when facebookSignInRequested != null:
        return facebookSignInRequested();
      case AuthLogoutRequested() when logoutRequested != null:
        return logoutRequested();
      case AuthCheckStatus() when checkAuthStatus != null:
        return checkAuthStatus();
      case _:
        return null;
    }
  }
}

/// @nodoc

class AuthLoginRequested implements AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthLoginRequestedCopyWith<AuthLoginRequested> get copyWith =>
      _$AuthLoginRequestedCopyWithImpl<AuthLoginRequested>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthLoginRequested &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  @override
  String toString() {
    return 'AuthEvent.loginRequested(email: $email, password: $password)';
  }
}

/// @nodoc
abstract mixin class $AuthLoginRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthLoginRequestedCopyWith(
          AuthLoginRequested value, $Res Function(AuthLoginRequested) _then) =
      _$AuthLoginRequestedCopyWithImpl;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$AuthLoginRequestedCopyWithImpl<$Res>
    implements $AuthLoginRequestedCopyWith<$Res> {
  _$AuthLoginRequestedCopyWithImpl(this._self, this._then);

  final AuthLoginRequested _self;
  final $Res Function(AuthLoginRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(AuthLoginRequested(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthRegisterRequested implements AuthEvent {
  const AuthRegisterRequested({required this.email, required this.password});

  final String email;
  final String password;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthRegisterRequestedCopyWith<AuthRegisterRequested> get copyWith =>
      _$AuthRegisterRequestedCopyWithImpl<AuthRegisterRequested>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthRegisterRequested &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  @override
  String toString() {
    return 'AuthEvent.registerRequested(email: $email, password: $password)';
  }
}

/// @nodoc
abstract mixin class $AuthRegisterRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthRegisterRequestedCopyWith(AuthRegisterRequested value,
          $Res Function(AuthRegisterRequested) _then) =
      _$AuthRegisterRequestedCopyWithImpl;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$AuthRegisterRequestedCopyWithImpl<$Res>
    implements $AuthRegisterRequestedCopyWith<$Res> {
  _$AuthRegisterRequestedCopyWithImpl(this._self, this._then);

  final AuthRegisterRequested _self;
  final $Res Function(AuthRegisterRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(AuthRegisterRequested(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthForgotPasswordRequested implements AuthEvent {
  const AuthForgotPasswordRequested({required this.email});

  final String email;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthForgotPasswordRequestedCopyWith<AuthForgotPasswordRequested>
      get copyWith => _$AuthForgotPasswordRequestedCopyWithImpl<
          AuthForgotPasswordRequested>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthForgotPasswordRequested &&
            (identical(other.email, email) || other.email == email));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email);

  @override
  String toString() {
    return 'AuthEvent.forgotPasswordRequested(email: $email)';
  }
}

/// @nodoc
abstract mixin class $AuthForgotPasswordRequestedCopyWith<$Res>
    implements $AuthEventCopyWith<$Res> {
  factory $AuthForgotPasswordRequestedCopyWith(
          AuthForgotPasswordRequested value,
          $Res Function(AuthForgotPasswordRequested) _then) =
      _$AuthForgotPasswordRequestedCopyWithImpl;
  @useResult
  $Res call({String email});
}

/// @nodoc
class _$AuthForgotPasswordRequestedCopyWithImpl<$Res>
    implements $AuthForgotPasswordRequestedCopyWith<$Res> {
  _$AuthForgotPasswordRequestedCopyWithImpl(this._self, this._then);

  final AuthForgotPasswordRequested _self;
  final $Res Function(AuthForgotPasswordRequested) _then;

  /// Create a copy of AuthEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
  }) {
    return _then(AuthForgotPasswordRequested(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class AuthGoogleSignInRequested implements AuthEvent {
  const AuthGoogleSignInRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthGoogleSignInRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.googleSignInRequested()';
  }
}

/// @nodoc

class AuthFacebookSignInRequested implements AuthEvent {
  const AuthFacebookSignInRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthFacebookSignInRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.facebookSignInRequested()';
  }
}

/// @nodoc

class AuthLogoutRequested implements AuthEvent {
  const AuthLogoutRequested();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthLogoutRequested);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.logoutRequested()';
  }
}

/// @nodoc

class AuthCheckStatus implements AuthEvent {
  const AuthCheckStatus();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is AuthCheckStatus);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'AuthEvent.checkAuthStatus()';
  }
}

// dart format on
